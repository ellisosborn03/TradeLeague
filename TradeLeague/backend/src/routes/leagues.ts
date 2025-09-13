import express from 'express';
import Joi from 'joi';
import { auth } from '../middleware/auth';
import { DatabaseService } from '../services/DatabaseService';
import { AptosService } from '../services/AptosService';
import { wsManager } from '../services/WebSocketManager';

const router = express.Router();
const dbService = new DatabaseService();
const aptosService = new AptosService();

// Validation schemas
const createLeagueSchema = Joi.object({
  name: Joi.string().min(3).max(100).required(),
  entryFee: Joi.number().min(0).required(),
  duration: Joi.number().min(3600).max(2592000).required(), // 1 hour to 30 days
  isPublic: Joi.boolean().required(),
  maxParticipants: Joi.number().min(2).max(10000).required(),
  sponsorName: Joi.string().optional(),
  sponsorLogo: Joi.string().optional(),
});

/**
 * @route GET /api/leagues
 * @desc Get all public leagues
 */
router.get('/', async (req, res) => {
  try {
    const limit = parseInt(req.query.limit as string) || 50;
    const offset = parseInt(req.query.offset as string) || 0;
    
    const leagues = await dbService.getAllLeagues(limit, offset);
    
    // Add participant counts and current status
    const enrichedLeagues = await Promise.all(
      leagues.map(async (league) => {
        // Get leaderboard data from Aptos
        const leaderboard = await aptosService.queryLeaderboard(league.id);
        
        return {
          ...league,
          participantCount: leaderboard.length,
          isActive: new Date() < (league.endTime || new Date(Date.now() + 86400000)),
          leaderboard: leaderboard.slice(0, 3), // Top 3 for preview
        };
      })
    );

    res.json({
      leagues: enrichedLeagues,
      pagination: {
        limit,
        offset,
        hasMore: leagues.length === limit,
      },
    });
  } catch (error) {
    console.error('Get leagues error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * @route GET /api/leagues/:id
 * @desc Get league details with full leaderboard
 */
router.get('/:id', async (req, res) => {
  try {
    const league = await dbService.getLeagueById(req.params.id);
    if (!league) {
      return res.status(404).json({ error: 'League not found' });
    }

    // Get full leaderboard from Aptos
    const leaderboard = await aptosService.queryLeaderboard(league.id);
    
    res.json({
      ...league,
      leaderboard,
      participantCount: leaderboard.length,
      isActive: new Date() < (league.endTime || new Date(Date.now() + 86400000)),
    });
  } catch (error) {
    console.error('Get league error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * @route POST /api/leagues
 * @desc Create a new league
 */
router.post('/', auth, async (req, res) => {
  try {
    const { error, value } = createLeagueSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        error: 'Validation error',
        details: error.details[0].message,
      });
    }

    const { name, entryFee, duration, isPublic, maxParticipants, sponsorName, sponsorLogo } = value;

    // Calculate end time
    const startTime = new Date();
    const endTime = new Date(Date.now() + duration * 1000);

    // Create league in database
    const league = await dbService.createLeague({
      name,
      creatorId: req.user!.userId,
      entryFee,
      prizePool: 0,
      startTime,
      endTime,
      isPublic,
      maxParticipants,
      sponsorName,
      sponsorLogo,
    });

    // Auto-join creator to the league
    await dbService.joinLeague(req.user!.userId, league.id);

    // Broadcast new league creation
    if (isPublic) {
      wsManager.broadcast('leagues', {
        type: 'league_created',
        league,
      });
    }

    res.status(201).json({
      league: {
        ...league,
        participantCount: 1,
        leaderboard: [],
      },
    });
  } catch (error) {
    console.error('Create league error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * @route POST /api/leagues/:id/join
 * @desc Join a league
 */
router.post('/:id/join', auth, async (req, res) => {
  try {
    const league = await dbService.getLeagueById(req.params.id);
    if (!league) {
      return res.status(404).json({ error: 'League not found' });
    }

    // Check if league is still active
    if (league.endTime && new Date() > league.endTime) {
      return res.status(400).json({ error: 'League has ended' });
    }

    // Check if user is already in the league
    const leaderboard = await aptosService.queryLeaderboard(league.id);
    const userInLeague = leaderboard.find(entry => entry.user === req.user!.walletAddress);
    
    if (userInLeague) {
      return res.status(409).json({ error: 'Already joined this league' });
    }

    // Check participant limit
    if (leaderboard.length >= league.maxParticipants) {
      return res.status(400).json({ error: 'League is full' });
    }

    // Join league in database
    await dbService.joinLeague(req.user!.userId, league.id);

    // Broadcast league update
    wsManager.broadcastLeaderboardUpdate(league.id, [
      ...leaderboard,
      {
        user: req.user!.walletAddress,
        score: 0,
        rank: leaderboard.length + 1,
        percentageGain: 0,
      },
    ]);

    res.json({
      message: 'Successfully joined league',
      league: {
        ...league,
        participantCount: leaderboard.length + 1,
      },
    });
  } catch (error) {
    console.error('Join league error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * @route GET /api/leagues/:id/leaderboard
 * @desc Get league leaderboard with real-time data
 */
router.get('/:id/leaderboard', async (req, res) => {
  try {
    const league = await dbService.getLeagueById(req.params.id);
    if (!league) {
      return res.status(404).json({ error: 'League not found' });
    }

    const leaderboard = await aptosService.queryLeaderboard(league.id);
    
    res.json({
      leagueId: league.id,
      leaderboard,
      lastUpdated: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Get leaderboard error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * @route GET /api/leagues/user/:userId
 * @desc Get leagues for a specific user
 */
router.get('/user/:userId', async (req, res) => {
  try {
    // This would typically require database queries for user's leagues
    // For now, return mock data
    res.json({
      activeLeagues: [],
      completedLeagues: [],
      totalParticipated: 0,
    });
  } catch (error) {
    console.error('Get user leagues error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;