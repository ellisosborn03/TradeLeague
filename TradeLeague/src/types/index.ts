export interface User {
  id: string;
  walletAddress: string;
  username: string;
  avatar?: string;
  totalVolume: number;
  inviteCode: string;
  createdAt: Date;
  currentScore: number;
  rank?: number;
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
  participants: LeagueParticipant[];
  sponsorName?: string;
  sponsorLogo?: string;
}

export interface LeagueParticipant {
  userId: string;
  user: User;
  joinedAt: Date;
  currentScore: number;
  rank: number;
  percentageGain: number;
}

export interface Vault {
  id: string;
  managerId: string;
  manager: User;
  name: string;
  strategy: VaultStrategy;
  venue: 'Hyperion' | 'Merkle' | 'Tapp';
  totalAUM: number;
  performanceFee: number;
  allTimeReturn: number;
  weeklyReturn: number;
  monthlyReturn: number;
  followers: number;
  description: string;
  riskLevel: 'Conservative' | 'Moderate' | 'Aggressive';
}

export type VaultStrategy = 
  | 'Market Making'
  | 'Yield Farming'
  | 'Arbitrage'
  | 'Perps Trading'
  | 'Liquidity Provision';

export interface VaultFollowing {
  vaultId: string;
  vault: Vault;
  amount: number;
  followedAt: Date;
  currentValue: number;
  pnl: number;
  pnlPercentage: number;
}

export interface PredictionMarket {
  id: string;
  sponsor: string;
  sponsorLogo: string;
  question: string;
  outcomes: PredictionOutcome[];
  totalStaked: number;
  resolutionTime: Date;
  resolved: boolean;
  winningOutcome?: number;
  marketType: 'Binary' | 'Multiple';
  category: 'Price' | 'Volume' | 'CrossChain' | 'Derivatives';
}

export interface PredictionOutcome {
  index: number;
  label: string;
  probability: number;
  totalStaked: number;
  color: string;
}

export interface UserPrediction {
  marketId: string;
  market: PredictionMarket;
  outcomeIndex: number;
  stake: number;
  potentialPayout: number;
  placedAt: Date;
  settled: boolean;
  won?: boolean;
}

export interface Portfolio {
  totalValue: number;
  todayChange: number;
  todayChangePercentage: number;
  allTimeChange: number;
  allTimeChangePercentage: number;
  vaultFollowings: VaultFollowing[];
  predictions: UserPrediction[];
  rewards: Reward[];
}

export interface Reward {
  id: string;
  type: 'League' | 'Prediction' | 'Referral' | 'Achievement';
  amount: number;
  description: string;
  claimedAt?: Date;
  expiresAt?: Date;
}

export interface Transaction {
  id: string;
  type: 'Deposit' | 'Withdraw' | 'Follow' | 'Unfollow' | 'Prediction' | 'Reward';
  amount: number;
  hash: string;
  status: 'Pending' | 'Success' | 'Failed';
  timestamp: Date;
  description: string;
}