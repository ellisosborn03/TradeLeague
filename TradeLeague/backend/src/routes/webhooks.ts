import express from 'express';
import { wsManager } from '../services/WebSocketManager';
import { DatabaseService } from '../services/DatabaseService';

const router = express.Router();
const dbService = new DatabaseService();

/**
 * @route POST /api/webhooks/aptos-events
 * @desc Handle Aptos blockchain events
 */
router.post('/aptos-events', async (req, res) => {
  try {
    const { events } = req.body;

    for (const event of events) {
      await processAptosEvent(event);
    }

    res.json({ message: 'Events processed successfully' });
  } catch (error) {
    console.error('Webhook processing error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

async function processAptosEvent(event: any) {
  const { type, data } = event;

  switch (type) {
    case 'LeagueCreatedEvent':
      wsManager.broadcast('leagues', {
        type: 'league_created',
        league: data,
      });
      break;

    case 'UserJoinedEvent':
      wsManager.broadcastLeaderboardUpdate(data.league_id, []);
      break;

    case 'ScoreUpdatedEvent':
      wsManager.broadcastLeaderboardUpdate(data.league_id, []);
      break;

    case 'VaultCreatedEvent':
      wsManager.broadcast('vaults', {
        type: 'vault_created',
        vault: data,
      });
      break;

    case 'TradeExecutedEvent':
      wsManager.broadcastVaultUpdate(data.vault_id, data);
      break;

    case 'MarketCreatedEvent':
      wsManager.broadcast('predictions', {
        type: 'market_created',
        market: data,
      });
      break;

    case 'PredictionPlacedEvent':
      wsManager.broadcastNewPrediction(data.market_id, data);
      break;

    case 'RewardDistributedEvent':
      // Notify all recipients
      data.distributions.forEach((dist: any) => {
        wsManager.sendSystemNotification(dist.recipient, {
          title: 'Reward Received!',
          message: `You received ${dist.amount} USDC`,
          type: 'success',
        });
      });
      break;

    default:
      console.log('Unknown event type:', type);
  }
}

export default router;