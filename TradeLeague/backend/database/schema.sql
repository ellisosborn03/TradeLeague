-- TradeLeague Database Schema
-- PostgreSQL Database Setup

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(30) UNIQUE NOT NULL,
    wallet_address VARCHAR(66) UNIQUE NOT NULL,
    avatar_url TEXT,
    total_volume DECIMAL(20,2) DEFAULT 0,
    invite_code VARCHAR(10) UNIQUE NOT NULL,
    invited_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP,
    
    CONSTRAINT valid_wallet_address CHECK (wallet_address ~ '^0x[a-fA-F0-9]{64}$'),
    CONSTRAINT valid_username CHECK (length(username) >= 3)
);

-- Create indexes
CREATE INDEX idx_users_wallet_address ON users(wallet_address);
CREATE INDEX idx_users_invite_code ON users(invite_code);
CREATE INDEX idx_users_username ON users(username);

-- Leagues Table
CREATE TABLE leagues (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    creator_id UUID REFERENCES users(id) NOT NULL,
    entry_fee DECIMAL(10,2) DEFAULT 0,
    prize_pool DECIMAL(20,2) DEFAULT 0,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    is_public BOOLEAN DEFAULT true,
    max_participants INTEGER DEFAULT 100,
    sponsor_name VARCHAR(100),
    sponsor_logo TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    
    CONSTRAINT valid_entry_fee CHECK (entry_fee >= 0),
    CONSTRAINT valid_prize_pool CHECK (prize_pool >= 0),
    CONSTRAINT valid_max_participants CHECK (max_participants >= 2 AND max_participants <= 10000),
    CONSTRAINT valid_end_time CHECK (end_time IS NULL OR end_time > start_time)
);

-- Create indexes
CREATE INDEX idx_leagues_creator_id ON leagues(creator_id);
CREATE INDEX idx_leagues_is_public ON leagues(is_public);
CREATE INDEX idx_leagues_start_time ON leagues(start_time);

-- League Participants Table
CREATE TABLE league_participants (
    league_id UUID REFERENCES leagues(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP DEFAULT NOW(),
    current_score DECIMAL(20,2) DEFAULT 0,
    rank INTEGER DEFAULT 0,
    
    PRIMARY KEY (league_id, user_id)
);

-- Create indexes
CREATE INDEX idx_league_participants_user_id ON league_participants(user_id);
CREATE INDEX idx_league_participants_score ON league_participants(current_score DESC);

-- Vaults Table
CREATE TABLE vaults (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    manager_id UUID REFERENCES users(id) NOT NULL,
    name VARCHAR(100) NOT NULL,
    strategy VARCHAR(50) NOT NULL,
    venue VARCHAR(50) NOT NULL,
    total_aum DECIMAL(20,2) DEFAULT 0,
    performance_fee DECIMAL(5,2) DEFAULT 0,
    all_time_return DECIMAL(10,2) DEFAULT 0,
    weekly_return DECIMAL(10,2) DEFAULT 0,
    monthly_return DECIMAL(10,2) DEFAULT 0,
    followers INTEGER DEFAULT 0,
    description TEXT,
    risk_level VARCHAR(20) DEFAULT 'Moderate',
    created_at TIMESTAMP DEFAULT NOW(),
    
    CONSTRAINT valid_performance_fee CHECK (performance_fee >= 0 AND performance_fee <= 100),
    CONSTRAINT valid_risk_level CHECK (risk_level IN ('Conservative', 'Moderate', 'Aggressive'))
);

-- Create indexes
CREATE INDEX idx_vaults_manager_id ON vaults(manager_id);
CREATE INDEX idx_vaults_venue ON vaults(venue);
CREATE INDEX idx_vaults_total_aum ON vaults(total_aum DESC);
CREATE INDEX idx_vaults_all_time_return ON vaults(all_time_return DESC);

-- Vault Followers Table
CREATE TABLE vault_followers (
    vault_id UUID REFERENCES vaults(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(20,2) NOT NULL,
    followed_at TIMESTAMP DEFAULT NOW(),
    current_value DECIMAL(20,2) NOT NULL,
    
    PRIMARY KEY (vault_id, user_id),
    CONSTRAINT valid_amount CHECK (amount > 0)
);

-- Create indexes
CREATE INDEX idx_vault_followers_user_id ON vault_followers(user_id);
CREATE INDEX idx_vault_followers_amount ON vault_followers(amount DESC);

-- Predictions Table
CREATE TABLE predictions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sponsor VARCHAR(100) NOT NULL,
    sponsor_logo TEXT,
    question TEXT NOT NULL,
    outcomes JSONB NOT NULL,
    total_staked DECIMAL(20,2) DEFAULT 0,
    resolution_time TIMESTAMP NOT NULL,
    resolved BOOLEAN DEFAULT false,
    winning_outcome INTEGER,
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    
    CONSTRAINT valid_total_staked CHECK (total_staked >= 0),
    CONSTRAINT valid_outcomes CHECK (jsonb_array_length(outcomes) >= 2),
    CONSTRAINT valid_category CHECK (category IN ('Price', 'Volume', 'CrossChain', 'Derivatives'))
);

-- Create indexes
CREATE INDEX idx_predictions_sponsor ON predictions(sponsor);
CREATE INDEX idx_predictions_category ON predictions(category);
CREATE INDEX idx_predictions_resolution_time ON predictions(resolution_time);
CREATE INDEX idx_predictions_resolved ON predictions(resolved);

-- User Predictions Table
CREATE TABLE user_predictions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    market_id UUID REFERENCES predictions(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    outcome_index INTEGER NOT NULL,
    stake DECIMAL(10,2) NOT NULL,
    potential_payout DECIMAL(10,2) NOT NULL,
    placed_at TIMESTAMP DEFAULT NOW(),
    settled BOOLEAN DEFAULT false,
    won BOOLEAN DEFAULT false,
    
    CONSTRAINT valid_stake CHECK (stake > 0),
    CONSTRAINT valid_outcome_index CHECK (outcome_index >= 0)
);

-- Create indexes
CREATE INDEX idx_user_predictions_market_id ON user_predictions(market_id);
CREATE INDEX idx_user_predictions_user_id ON user_predictions(user_id);
CREATE INDEX idx_user_predictions_placed_at ON user_predictions(placed_at DESC);

-- Transactions Table (for tracking all user transactions)
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) NOT NULL,
    type VARCHAR(20) NOT NULL,
    amount DECIMAL(20,2) NOT NULL,
    hash VARCHAR(66),
    status VARCHAR(20) DEFAULT 'Pending',
    description TEXT,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    
    CONSTRAINT valid_type CHECK (type IN ('Deposit', 'Withdraw', 'Follow', 'Unfollow', 'Prediction', 'Reward')),
    CONSTRAINT valid_status CHECK (status IN ('Pending', 'Success', 'Failed')),
    CONSTRAINT valid_amount CHECK (amount >= 0)
);

-- Create indexes
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_type ON transactions(type);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_created_at ON transactions(created_at DESC);
CREATE INDEX idx_transactions_hash ON transactions(hash);

-- Rewards Table
CREATE TABLE rewards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) NOT NULL,
    type VARCHAR(20) NOT NULL,
    amount DECIMAL(20,2) NOT NULL,
    description TEXT NOT NULL,
    claimed_at TIMESTAMP,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    
    CONSTRAINT valid_reward_type CHECK (type IN ('League', 'Prediction', 'Referral', 'Achievement')),
    CONSTRAINT valid_amount CHECK (amount > 0)
);

-- Create indexes
CREATE INDEX idx_rewards_user_id ON rewards(user_id);
CREATE INDEX idx_rewards_type ON rewards(type);
CREATE INDEX idx_rewards_claimed_at ON rewards(claimed_at);
CREATE INDEX idx_rewards_expires_at ON rewards(expires_at);

-- Invitations Table (for tracking referral relationships)
CREATE TABLE invitations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    inviter_id UUID REFERENCES users(id) NOT NULL,
    invitee_id UUID REFERENCES users(id),
    invite_code VARCHAR(10) NOT NULL,
    used_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(invite_code)
);

-- Create indexes
CREATE INDEX idx_invitations_inviter_id ON invitations(inviter_id);
CREATE INDEX idx_invitations_invite_code ON invitations(invite_code);
CREATE INDEX idx_invitations_used_at ON invitations(used_at);

-- Events Table (for tracking blockchain events)
CREATE TABLE blockchain_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_type VARCHAR(100) NOT NULL,
    transaction_hash VARCHAR(66) NOT NULL,
    sequence_number BIGINT NOT NULL,
    account_address VARCHAR(66) NOT NULL,
    event_data JSONB NOT NULL,
    processed BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW(),
    
    UNIQUE(transaction_hash, sequence_number)
);

-- Create indexes
CREATE INDEX idx_blockchain_events_type ON blockchain_events(event_type);
CREATE INDEX idx_blockchain_events_hash ON blockchain_events(transaction_hash);
CREATE INDEX idx_blockchain_events_sequence ON blockchain_events(sequence_number);
CREATE INDEX idx_blockchain_events_processed ON blockchain_events(processed);
CREATE INDEX idx_blockchain_events_created_at ON blockchain_events(created_at DESC);

-- Create functions for common operations

-- Function to update user volume
CREATE OR REPLACE FUNCTION update_user_volume()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE users 
    SET total_volume = total_volume + NEW.amount
    WHERE id = NEW.user_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update user volume on transactions
CREATE TRIGGER trigger_update_user_volume
    AFTER INSERT ON transactions
    FOR EACH ROW
    WHEN (NEW.type IN ('Follow', 'Prediction') AND NEW.status = 'Success')
    EXECUTE FUNCTION update_user_volume();

-- Function to update vault followers count
CREATE OR REPLACE FUNCTION update_vault_followers()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE vaults 
        SET followers = followers + 1,
            total_aum = total_aum + NEW.amount
        WHERE id = NEW.vault_id;
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE vaults 
        SET followers = followers - 1,
            total_aum = total_aum - OLD.amount
        WHERE id = OLD.vault_id;
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Triggers for vault followers
CREATE TRIGGER trigger_vault_followers_insert
    AFTER INSERT ON vault_followers
    FOR EACH ROW
    EXECUTE FUNCTION update_vault_followers();

CREATE TRIGGER trigger_vault_followers_delete
    AFTER DELETE ON vault_followers
    FOR EACH ROW
    EXECUTE FUNCTION update_vault_followers();

-- Insert some seed data for development
INSERT INTO users (username, wallet_address, invite_code) VALUES
('tradeleague_admin', '0x0000000000000000000000000000000000000000000000000000000000000001', 'ADMIN001'),
('demo_user', '0x0000000000000000000000000000000000000000000000000000000000000002', 'DEMO0001');

-- Insert sample leagues
INSERT INTO leagues (name, creator_id, entry_fee, is_public, max_participants, sponsor_name, sponsor_logo) VALUES
('Circle League', (SELECT id FROM users WHERE username = 'tradeleague_admin'), 0, true, 1000, 'Circle', '⭕'),
('Hyperion Week', (SELECT id FROM users WHERE username = 'tradeleague_admin'), 100, true, 500, 'Hyperion', '🌟');

-- Insert sample vaults
INSERT INTO vaults (manager_id, name, strategy, venue, performance_fee, description, risk_level) VALUES
((SELECT id FROM users WHERE username = 'demo_user'), 'Yield Maximizer', 'Yield Farming', 'Hyperion', 10, 'Automated yield farming across multiple protocols', 'Moderate'),
((SELECT id FROM users WHERE username = 'demo_user'), 'Perps Alpha', 'Perps Trading', 'Merkle', 15, 'High-frequency perpetual futures trading', 'Aggressive');

-- Insert sample prediction markets
INSERT INTO predictions (sponsor, sponsor_logo, question, outcomes, resolution_time, category) VALUES
('Panora', '📊', 'Will APT be above $20 by Friday?', '["Yes", "No"]', NOW() + INTERVAL '3 days', 'Price'),
('Kana Labs', '🌉', 'Which chain will have more volume this week?', '["Aptos", "Ethereum", "Solana"]', NOW() + INTERVAL '7 days', 'CrossChain');

-- Grant necessary permissions (adjust as needed for your setup)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO tradeleague_user;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO tradeleague_user;