import express from 'express';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import Joi from 'joi';
import { AptosService } from '../services/AptosService';
import { DatabaseService } from '../services/DatabaseService';
import { auth } from '../middleware/auth';

const router = express.Router();
const aptosService = new AptosService();
const dbService = new DatabaseService();

// Validation schemas
const walletLoginSchema = Joi.object({
  walletAddress: Joi.string().required(),
  signature: Joi.string().required(),
  message: Joi.string().required(),
  timestamp: Joi.number().required(),
});

const createAccountSchema = Joi.object({
  username: Joi.string().min(3).max(30).required(),
  walletAddress: Joi.string().required(),
  inviteCode: Joi.string().optional(),
});

/**
 * @route POST /api/auth/wallet-login
 * @desc Authenticate user with wallet signature
 */
router.post('/wallet-login', async (req, res) => {
  try {
    const { error, value } = walletLoginSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        error: 'Validation error',
        details: error.details[0].message,
      });
    }

    const { walletAddress, signature, message, timestamp } = value;

    // Verify timestamp (should be within 5 minutes)
    const now = Date.now();
    if (Math.abs(now - timestamp) > 5 * 60 * 1000) {
      return res.status(400).json({
        error: 'Request expired',
      });
    }

    // Verify signature
    const isValidSignature = await aptosService.verifySignature(
      walletAddress,
      message,
      signature
    );

    if (!isValidSignature) {
      return res.status(401).json({
        error: 'Invalid signature',
      });
    }

    // Get or create user
    let user = await dbService.getUserByWallet(walletAddress);
    if (!user) {
      // Create new user if doesn't exist
      user = await dbService.createUser({
        walletAddress,
        username: `user_${walletAddress.slice(-6)}`,
        inviteCode: generateInviteCode(),
      });
    }

    // Update last login
    await dbService.updateUserLastLogin(user.id);

    // Generate JWT token
    const token = jwt.sign(
      { 
        userId: user.id, 
        walletAddress: user.walletAddress 
      },
      process.env.JWT_SECRET!,
      { expiresIn: '7d' }
    );

    res.json({
      token,
      user: {
        id: user.id,
        username: user.username,
        walletAddress: user.walletAddress,
        inviteCode: user.inviteCode,
        totalVolume: user.totalVolume,
        createdAt: user.createdAt,
      },
    });
  } catch (error) {
    console.error('Wallet login error:', error);
    res.status(500).json({
      error: 'Internal server error',
    });
  }
});

/**
 * @route POST /api/auth/create-account
 * @desc Create new user account with wallet
 */
router.post('/create-account', async (req, res) => {
  try {
    const { error, value } = createAccountSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        error: 'Validation error',
        details: error.details[0].message,
      });
    }

    const { username, walletAddress, inviteCode } = value;

    // Check if user already exists
    const existingUser = await dbService.getUserByWallet(walletAddress);
    if (existingUser) {
      return res.status(409).json({
        error: 'User already exists',
      });
    }

    // Check if username is taken
    const existingUsername = await dbService.getUserByUsername(username);
    if (existingUsername) {
      return res.status(409).json({
        error: 'Username already taken',
      });
    }

    // Validate invite code if provided
    let inviter = null;
    if (inviteCode) {
      inviter = await dbService.getUserByInviteCode(inviteCode);
      if (!inviter) {
        return res.status(400).json({
          error: 'Invalid invite code',
        });
      }
    }

    // Create user
    const user = await dbService.createUser({
      username,
      walletAddress,
      inviteCode: generateInviteCode(),
      invitedBy: inviter?.id,
    });

    // Fund account with testnet tokens
    try {
      await aptosService.fundAccount(walletAddress);
    } catch (fundError) {
      console.warn('Failed to fund account:', fundError);
      // Continue with account creation even if funding fails
    }

    // Generate JWT token
    const token = jwt.sign(
      { 
        userId: user.id, 
        walletAddress: user.walletAddress 
      },
      process.env.JWT_SECRET!,
      { expiresIn: '7d' }
    );

    res.status(201).json({
      token,
      user: {
        id: user.id,
        username: user.username,
        walletAddress: user.walletAddress,
        inviteCode: user.inviteCode,
        totalVolume: user.totalVolume,
        createdAt: user.createdAt,
      },
    });
  } catch (error) {
    console.error('Create account error:', error);
    res.status(500).json({
      error: 'Internal server error',
    });
  }
});

/**
 * @route GET /api/auth/me
 * @desc Get current user profile
 */
router.get('/me', auth, async (req, res) => {
  try {
    const user = await dbService.getUserById(req.user!.userId);
    if (!user) {
      return res.status(404).json({
        error: 'User not found',
      });
    }

    res.json({
      user: {
        id: user.id,
        username: user.username,
        walletAddress: user.walletAddress,
        inviteCode: user.inviteCode,
        totalVolume: user.totalVolume,
        createdAt: user.createdAt,
        lastLogin: user.lastLogin,
      },
    });
  } catch (error) {
    console.error('Get user profile error:', error);
    res.status(500).json({
      error: 'Internal server error',
    });
  }
});

/**
 * @route POST /api/auth/refresh
 * @desc Refresh JWT token
 */
router.post('/refresh', auth, async (req, res) => {
  try {
    const user = await dbService.getUserById(req.user!.userId);
    if (!user) {
      return res.status(404).json({
        error: 'User not found',
      });
    }

    // Generate new JWT token
    const token = jwt.sign(
      { 
        userId: user.id, 
        walletAddress: user.walletAddress 
      },
      process.env.JWT_SECRET!,
      { expiresIn: '7d' }
    );

    res.json({ token });
  } catch (error) {
    console.error('Token refresh error:', error);
    res.status(500).json({
      error: 'Internal server error',
    });
  }
});

// Helper function to generate invite code
function generateInviteCode(): string {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let result = '';
  for (let i = 0; i < 8; i++) {
    result += characters.charAt(Math.floor(Math.random() * characters.length));
  }
  return result;
}

export default router;