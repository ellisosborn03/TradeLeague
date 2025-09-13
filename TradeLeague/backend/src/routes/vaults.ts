import express from 'express';
import { auth, optionalAuth } from '../middleware/auth';
import { DatabaseService } from '../services/DatabaseService';
import { AptosService } from '../services/AptosService';

const router = express.Router();
const dbService = new DatabaseService();
const aptosService = new AptosService();

/**
 * @route GET /api/vaults
 * @desc Get all vaults with performance data
 */
router.get('/', optionalAuth, async (req, res) => {
  try {
    const limit = parseInt(req.query.limit as string) || 50;
    const offset = parseInt(req.query.offset as string) || 0;
    const venue = req.query.venue as string;
    
    let vaults = await dbService.getAllVaults(limit, offset);
    
    // Filter by venue if specified
    if (venue && venue !== 'All') {
      vaults = vaults.filter(vault => vault.venue === venue);
    }
    
    // Enrich with real-time performance data
    const enrichedVaults = await Promise.all(
      vaults.map(async (vault) => {
        const performance = await aptosService.queryVaultPerformance(vault.id);
        return {
          ...vault,
          ...performance,
        };
      })
    );

    res.json({
      vaults: enrichedVaults,
      pagination: { limit, offset, hasMore: vaults.length === limit },
    });
  } catch (error) {
    console.error('Get vaults error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

/**
 * @route POST /api/vaults/:id/follow
 * @desc Follow a vault
 */
router.post('/:id/follow', auth, async (req, res) => {
  try {
    const { amount } = req.body;
    const vault = await dbService.getVaultById(req.params.id);
    
    if (!vault) {
      return res.status(404).json({ error: 'Vault not found' });
    }

    await dbService.followVault(req.user!.userId, vault.id, amount);
    
    res.json({ message: 'Successfully followed vault' });
  } catch (error) {
    console.error('Follow vault error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;