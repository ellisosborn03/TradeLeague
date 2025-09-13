import express from 'express';
import { auth } from '../middleware/auth';
import { DatabaseService } from '../services/DatabaseService';
import { AptosService } from '../services/AptosService';

const router = express.Router();
const dbService = new DatabaseService();
const aptosService = new AptosService();

/**
 * @route GET /api/users/profile
 * @desc Get user profile with portfolio data
 */
router.get('/profile', auth, async (req, res) => {
  try {
    const user = await dbService.getUserById(req.user!.userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Get wallet balance
    const balance = await aptosService.getAccountBalance(user.walletAddress);
    
    res.json({
      user: {
        ...user,
        balance,
      },
      portfolio: {
        totalValue: balance * 100, // Mock portfolio value
        todayChange: 23.45,
        todayChangePercentage: 1.92,
        allTimeChange: 245.67,
        allTimeChangePercentage: 24.56,
      },
    });
  } catch (error) {
    console.error('Get user profile error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * @route GET /api/users/leaderboard
 * @desc Get global leaderboard
 */
router.get('/leaderboard', async (req, res) => {
  try {
    // Mock global leaderboard data
    const leaderboard = [
      { rank: 1, username: '@whale', score: 342, percentageGain: 342 },
      { rank: 2, username: '@degen', score: 287, percentageGain: 287 },
      { rank: 3, username: '@trader', score: 198, percentageGain: 198 },
    ];

    res.json({ leaderboard });
  } catch (error) {
    console.error('Get leaderboard error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;