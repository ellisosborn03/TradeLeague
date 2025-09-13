import { Pool, PoolClient } from 'pg';

export interface User {
  id: string;
  username: string;
  walletAddress: string;
  inviteCode: string;
  totalVolume: number;
  invitedBy?: string;
  createdAt: Date;
  lastLogin?: Date;
}

export interface League {
  id: string;
  name: string;
  creatorId: string;
  entryFee: number;
  prizePool: number;
  startTime: Date;
  endTime?: Date;
  isPublic: boolean;
  maxParticipants: number;
  sponsorName?: string;
  sponsorLogo?: string;
  createdAt: Date;
}

export interface Vault {
  id: string;
  managerId: string;
  name: string;
  strategy: string;
  venue: string;
  totalAUM: number;
  performanceFee: number;
  allTimeReturn: number;
  weeklyReturn: number;
  monthlyReturn: number;
  followers: number;
  description: string;
  riskLevel: string;
  createdAt: Date;
}

export interface PredictionMarket {
  id: string;
  sponsor: string;
  sponsorLogo: string;
  question: string;
  outcomes: string[];
  totalStaked: number;
  resolutionTime: Date;
  resolved: boolean;
  winningOutcome?: number;
  category: string;
  createdAt: Date;
}

export class DatabaseService {
  private pool: Pool;

  constructor() {
    this.pool = new Pool({
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT || '5432'),
      database: process.env.DB_NAME || 'tradeleague',
      user: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD || 'postgres',
      max: 20,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 2000,
    });

    // Test connection on startup
    this.testConnection();
  }

  private async testConnection() {
    try {
      const client = await this.pool.connect();
      await client.query('SELECT NOW()');
      client.release();
      console.log('✅ Database connection established');
    } catch (error) {
      console.error('❌ Database connection failed:', error);
    }
  }

  async query(text: string, params?: any[]): Promise<any> {
    try {
      const result = await this.pool.query(text, params);
      return result;
    } catch (error) {
      console.error('Database query error:', error);
      throw error;
    }
  }

  // User operations
  async getUserById(id: string): Promise<User | null> {
    const result = await this.query(
      'SELECT * FROM users WHERE id = $1',
      [id]
    );
    return result.rows[0] || null;
  }

  async getUserByWallet(walletAddress: string): Promise<User | null> {
    const result = await this.query(
      'SELECT * FROM users WHERE wallet_address = $1',
      [walletAddress]
    );
    return result.rows[0] || null;
  }

  async getUserByUsername(username: string): Promise<User | null> {
    const result = await this.query(
      'SELECT * FROM users WHERE username = $1',
      [username]
    );
    return result.rows[0] || null;
  }

  async getUserByInviteCode(inviteCode: string): Promise<User | null> {
    const result = await this.query(
      'SELECT * FROM users WHERE invite_code = $1',
      [inviteCode]
    );
    return result.rows[0] || null;
  }

  async createUser(userData: {
    username: string;
    walletAddress: string;
    inviteCode: string;
    invitedBy?: string;
  }): Promise<User> {
    const { username, walletAddress, inviteCode, invitedBy } = userData;
    const result = await this.query(
      `INSERT INTO users (username, wallet_address, invite_code, invited_by, total_volume, created_at)
       VALUES ($1, $2, $3, $4, $5, NOW())
       RETURNING *`,
      [username, walletAddress, inviteCode, invitedBy, 0]
    );
    return result.rows[0];
  }

  async updateUserLastLogin(userId: string): Promise<void> {
    await this.query(
      'UPDATE users SET last_login = NOW() WHERE id = $1',
      [userId]
    );
  }

  // League operations
  async createLeague(leagueData: {
    name: string;
    creatorId: string;
    entryFee: number;
    prizePool: number;
    startTime: Date;
    endTime?: Date;
    isPublic: boolean;
    maxParticipants: number;
    sponsorName?: string;
    sponsorLogo?: string;
  }): Promise<League> {
    const {
      name,
      creatorId,
      entryFee,
      prizePool,
      startTime,
      endTime,
      isPublic,
      maxParticipants,
      sponsorName,
      sponsorLogo,
    } = leagueData;

    const result = await this.query(
      `INSERT INTO leagues (name, creator_id, entry_fee, prize_pool, start_time, end_time, is_public, max_participants, sponsor_name, sponsor_logo, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, NOW())
       RETURNING *`,
      [name, creatorId, entryFee, prizePool, startTime, endTime, isPublic, maxParticipants, sponsorName, sponsorLogo]
    );
    return result.rows[0];
  }

  async getLeagueById(id: string): Promise<League | null> {
    const result = await this.query(
      'SELECT * FROM leagues WHERE id = $1',
      [id]
    );
    return result.rows[0] || null;
  }

  async getAllLeagues(limit: number = 50, offset: number = 0): Promise<League[]> {
    const result = await this.query(
      'SELECT * FROM leagues WHERE is_public = true ORDER BY created_at DESC LIMIT $1 OFFSET $2',
      [limit, offset]
    );
    return result.rows;
  }

  async joinLeague(userId: string, leagueId: string): Promise<void> {
    await this.query(
      `INSERT INTO league_participants (league_id, user_id, joined_at, current_score, rank)
       VALUES ($1, $2, NOW(), 0, 0)`,
      [leagueId, userId]
    );
  }

  // Vault operations
  async createVault(vaultData: {
    managerId: string;
    name: string;
    strategy: string;
    venue: string;
    performanceFee: number;
    description: string;
    riskLevel: string;
  }): Promise<Vault> {
    const {
      managerId,
      name,
      strategy,
      venue,
      performanceFee,
      description,
      riskLevel,
    } = vaultData;

    const result = await this.query(
      `INSERT INTO vaults (manager_id, name, strategy, venue, total_aum, performance_fee, all_time_return, weekly_return, monthly_return, followers, description, risk_level, created_at)
       VALUES ($1, $2, $3, $4, 0, $5, 0, 0, 0, 0, $6, $7, NOW())
       RETURNING *`,
      [managerId, name, strategy, venue, performanceFee, description, riskLevel]
    );
    return result.rows[0];
  }

  async getVaultById(id: string): Promise<Vault | null> {
    const result = await this.query(
      'SELECT * FROM vaults WHERE id = $1',
      [id]
    );
    return result.rows[0] || null;
  }

  async getAllVaults(limit: number = 50, offset: number = 0): Promise<Vault[]> {
    const result = await this.query(
      'SELECT * FROM vaults ORDER BY total_aum DESC LIMIT $1 OFFSET $2',
      [limit, offset]
    );
    return result.rows;
  }

  async followVault(userId: string, vaultId: string, amount: number): Promise<void> {
    await this.query(
      `INSERT INTO vault_followers (vault_id, user_id, amount, followed_at, current_value)
       VALUES ($1, $2, $3, NOW(), $3)`,
      [vaultId, userId, amount]
    );
  }

  // Prediction Market operations
  async createPredictionMarket(marketData: {
    sponsor: string;
    sponsorLogo: string;
    question: string;
    outcomes: string[];
    resolutionTime: Date;
    category: string;
  }): Promise<PredictionMarket> {
    const {
      sponsor,
      sponsorLogo,
      question,
      outcomes,
      resolutionTime,
      category,
    } = marketData;

    const result = await this.query(
      `INSERT INTO predictions (sponsor, sponsor_logo, question, outcomes, total_staked, resolution_time, resolved, category, created_at)
       VALUES ($1, $2, $3, $4, 0, $5, false, $6, NOW())
       RETURNING *`,
      [sponsor, sponsorLogo, question, JSON.stringify(outcomes), resolutionTime, category]
    );
    return result.rows[0];
  }

  async getPredictionMarketById(id: string): Promise<PredictionMarket | null> {
    const result = await this.query(
      'SELECT * FROM predictions WHERE id = $1',
      [id]
    );
    return result.rows[0] || null;
  }

  async getAllPredictionMarkets(limit: number = 50, offset: number = 0): Promise<PredictionMarket[]> {
    const result = await this.query(
      'SELECT * FROM predictions ORDER BY created_at DESC LIMIT $1 OFFSET $2',
      [limit, offset]
    );
    return result.rows;
  }

  async placePrediction(userId: string, marketId: string, outcomeIndex: number, stake: number): Promise<void> {
    await this.query(
      `INSERT INTO user_predictions (market_id, user_id, outcome_index, stake, potential_payout, placed_at, settled, won)
       VALUES ($1, $2, $3, $4, $4, NOW(), false, false)`,
      [marketId, userId, outcomeIndex, stake]
    );
  }

  async close(): Promise<void> {
    await this.pool.end();
  }
}