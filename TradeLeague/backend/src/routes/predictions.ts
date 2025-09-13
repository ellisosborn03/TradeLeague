import express from 'express';
import { auth, optionalAuth } from '../middleware/auth';
import { DatabaseService } from '../services/DatabaseService';
import { AptosService } from '../services/AptosService';

const router = express.Router();
const dbService = new DatabaseService();
const aptosService = new AptosService();

/**
 * @route GET /api/predictions
 * @desc Get all prediction markets
 */
router.get('/', optionalAuth, async (req, res) => {
  try {
    const limit = parseInt(req.query.limit as string) || 50;
    const offset = parseInt(req.query.offset as string) || 0;
    const category = req.query.category as string;
    
    let markets = await dbService.getAllPredictionMarkets(limit, offset);
    
    // Filter by category if specified
    if (category && category !== 'All') {
      markets = markets.filter(market => market.category === category);
    }
    
    // Enrich with odds data
    const enrichedMarkets = await Promise.all(
      markets.map(async (market) => {
        const odds = await aptosService.queryPredictionMarketOdds(market.id);
        return {
          ...market,
          outcomes: market.outcomes,
          odds,
        };
      })
    );

    res.json({
      markets: enrichedMarkets,
      pagination: { limit, offset, hasMore: markets.length === limit },
    });
  } catch (error) {
    console.error('Get predictions error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * @route POST /api/predictions/:id/predict
 * @desc Place a prediction
 */
router.post('/:id/predict', auth, async (req, res) => {
  try {
    const { outcomeIndex, stake } = req.body;
    const market = await dbService.getPredictionMarketById(req.params.id);
    
    if (!market) {
      return res.status(404).json({ error: 'Market not found' });
    }

    await dbService.placePrediction(req.user!.userId, market.id, outcomeIndex, stake);
    
    res.json({ message: 'Prediction placed successfully' });
  } catch (error) {
    console.error('Place prediction error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;