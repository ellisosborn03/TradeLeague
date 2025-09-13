import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Share,
  Alert,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import { Colors } from '../constants/colors';
import { Typography } from '../constants/typography';
import { Card } from '../components/Card';
import { Button } from '../components/Button';
import { Avatar } from '../components/Avatar';
import { Portfolio, Transaction, Reward } from '../types';

const mockPortfolio: Portfolio = {
  totalValue: 12456.78,
  todayChange: 234.56,
  todayChangePercentage: 1.92,
  allTimeChange: 2456.78,
  allTimeChangePercentage: 24.56,
  vaultFollowings: [],
  predictions: [],
  rewards: [
    {
      id: '1',
      type: 'League',
      amount: 100,
      description: 'Weekly League Winner',
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
    },
    {
      id: '2',
      type: 'Referral',
      amount: 10,
      description: 'Friend joined with your code',
      claimedAt: new Date(),
    },
  ],
};

const mockTransactions: Transaction[] = [
  {
    id: '1',
    type: 'Follow',
    amount: 500,
    hash: '0xabc123...',
    status: 'Success',
    timestamp: new Date(Date.now() - 2 * 60 * 60 * 1000),
    description: 'Followed Yield Maximizer vault',
  },
  {
    id: '2',
    type: 'Prediction',
    amount: 50,
    hash: '0xdef456...',
    status: 'Success',
    timestamp: new Date(Date.now() - 5 * 60 * 60 * 1000),
    description: 'Predicted on APT price',
  },
  {
    id: '3',
    type: 'Reward',
    amount: 100,
    hash: '0xghi789...',
    status: 'Success',
    timestamp: new Date(Date.now() - 24 * 60 * 60 * 1000),
    description: 'Claimed league reward',
  },
];

export const ProfileScreen = () => {
  const [selectedTab, setSelectedTab] = useState<'portfolio' | 'activity' | 'wallet'>('portfolio');

  const handleShare = async () => {
    try {
      await Share.share({
        message: 'Join me on TradeLeague! Use my invite code: MOON123 🚀\n\nhttps://tradeleague.app/invite/MOON123',
        title: 'Join TradeLeague',
      });
    } catch (error) {
      Alert.alert('Error', 'Unable to share');
    }
  };

  const handleClaimReward = (reward: Reward) => {
    Alert.alert('Reward Claimed', `You claimed ${reward.amount} USDC!`);
  };

  const renderPortfolioTab = () => (
    <ScrollView style={styles.tabContent}>
      <Card style={styles.portfolioCard}>
        <LinearGradient
          colors={Colors.gradients.primary}
          style={styles.portfolioGradient}>
          <Text style={styles.portfolioLabel}>Total Portfolio Value</Text>
          <Text style={styles.portfolioValue}>${mockPortfolio.totalValue.toLocaleString()}</Text>
          
          <View style={styles.portfolioStats}>
            <View style={styles.portfolioStat}>
              <Text style={styles.portfolioStatLabel}>Today</Text>
              <Text style={[styles.portfolioStatValue, { color: Colors.success }]}>
                +${mockPortfolio.todayChange.toFixed(2)} ({mockPortfolio.todayChangePercentage}%)
              </Text>
            </View>
            <View style={styles.portfolioStat}>
              <Text style={styles.portfolioStatLabel}>All-Time</Text>
              <Text style={[styles.portfolioStatValue, { color: Colors.success }]}>
                +${mockPortfolio.allTimeChange.toFixed(2)} ({mockPortfolio.allTimeChangePercentage}%)
              </Text>
            </View>
          </View>
        </LinearGradient>
      </Card>

      <Text style={styles.sectionTitle}>Active Positions</Text>
      <Card style={styles.positionCard}>
        <Text style={styles.emptyText}>No active vault positions</Text>
        <Button
          title="Browse Vaults"
          onPress={() => {}}
          size="small"
          variant="outline"
          style={styles.browseButton}
        />
      </Card>

      <Text style={styles.sectionTitle}>Unclaimed Rewards</Text>
      {mockPortfolio.rewards
        .filter(r => !r.claimedAt)
        .map(reward => (
          <Card key={reward.id} style={styles.rewardCard}>
            <View style={styles.rewardInfo}>
              <Text style={styles.rewardType}>{reward.type}</Text>
              <Text style={styles.rewardDescription}>{reward.description}</Text>
              {reward.expiresAt && (
                <Text style={styles.rewardExpiry}>
                  Expires in {Math.ceil((reward.expiresAt.getTime() - Date.now()) / (1000 * 60 * 60 * 24))} days
                </Text>
              )}
            </View>
            <View style={styles.rewardAction}>
              <Text style={styles.rewardAmount}>{reward.amount} USDC</Text>
              <Button
                title="Claim"
                onPress={() => handleClaimReward(reward)}
                size="small"
                variant="primary"
              />
            </View>
          </Card>
        ))}
    </ScrollView>
  );

  const renderActivityTab = () => (
    <ScrollView style={styles.tabContent}>
      {mockTransactions.map(transaction => (
        <Card key={transaction.id} style={styles.transactionCard}>
          <View style={styles.transactionHeader}>
            <View style={[styles.transactionIcon, { backgroundColor: getTransactionColor(transaction.type) }]}>
              <Text style={styles.transactionIconText}>{getTransactionIcon(transaction.type)}</Text>
            </View>
            <View style={styles.transactionInfo}>
              <Text style={styles.transactionType}>{transaction.type}</Text>
              <Text style={styles.transactionDescription}>{transaction.description}</Text>
              <Text style={styles.transactionTime}>
                {getTimeAgo(transaction.timestamp)}
              </Text>
            </View>
            <View style={styles.transactionAmount}>
              <Text style={[
                styles.transactionAmountText,
                { color: transaction.type === 'Reward' ? Colors.success : Colors.text.primary }
              ]}>
                {transaction.type === 'Reward' ? '+' : '-'}${transaction.amount}
              </Text>
              <View style={[styles.statusBadge, { backgroundColor: getStatusColor(transaction.status) }]}>
                <Text style={styles.statusText}>{transaction.status}</Text>
              </View>
            </View>
          </View>
        </Card>
      ))}
    </ScrollView>
  );

  const renderWalletTab = () => (
    <ScrollView style={styles.tabContent}>
      <Card style={styles.walletCard}>
        <Text style={styles.walletLabel}>Wallet Address</Text>
        <Text style={styles.walletAddress}>0x1234...5678</Text>
        <Button
          title="Copy Address"
          onPress={() => {}}
          size="small"
          variant="outline"
          style={styles.walletButton}
        />
      </Card>

      <Card style={styles.balanceCard}>
        <Text style={styles.balanceLabel}>Available Balance</Text>
        <Text style={styles.balanceAmount}>1,234.56 USDC</Text>
        <View style={styles.balanceActions}>
          <Button
            title="Deposit"
            onPress={() => {}}
            size="small"
            variant="primary"
            style={styles.balanceButton}
          />
          <Button
            title="Withdraw"
            onPress={() => {}}
            size="small"
            variant="outline"
            style={styles.balanceButton}
          />
        </View>
      </Card>

      <Card style={styles.securityCard}>
        <Text style={styles.securityTitle}>Security</Text>
        <TouchableOpacity style={styles.securityItem}>
          <Text style={styles.securityItemText}>Export Private Key</Text>
          <Text style={styles.securityItemIcon}>→</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.securityItem}>
          <Text style={styles.securityItemText}>Recovery Phrase</Text>
          <Text style={styles.securityItemIcon}>→</Text>
        </TouchableOpacity>
      </Card>

      <Card style={styles.dangerCard}>
        <Text style={styles.dangerTitle}>Danger Zone</Text>
        <Button
          title="Reset Wallet"
          onPress={() => Alert.alert('Reset Wallet', 'This will delete your wallet. Are you sure?')}
          variant="danger"
          size="small"
        />
      </Card>
    </ScrollView>
  );

  const getTransactionIcon = (type: string) => {
    switch (type) {
      case 'Follow': return '📈';
      case 'Unfollow': return '📉';
      case 'Prediction': return '🔮';
      case 'Reward': return '🎁';
      case 'Deposit': return '⬇️';
      case 'Withdraw': return '⬆️';
      default: return '💰';
    }
  };

  const getTransactionColor = (type: string) => {
    switch (type) {
      case 'Follow': return Colors.primary;
      case 'Prediction': return Colors.warning;
      case 'Reward': return Colors.success;
      default: return Colors.surface;
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'Success': return Colors.success;
      case 'Pending': return Colors.warning;
      case 'Failed': return Colors.danger;
      default: return Colors.surface;
    }
  };

  const getTimeAgo = (date: Date) => {
    const seconds = Math.floor((Date.now() - date.getTime()) / 1000);
    if (seconds < 60) return 'Just now';
    const minutes = Math.floor(seconds / 60);
    if (minutes < 60) return `${minutes}m ago`;
    const hours = Math.floor(minutes / 60);
    if (hours < 24) return `${hours}h ago`;
    const days = Math.floor(hours / 24);
    return `${days}d ago`;
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Avatar name="@moonshot" size="large" showBorder />
        <View style={styles.headerInfo}>
          <Text style={styles.username}>@moonshot</Text>
          <Text style={styles.inviteCode}>Invite Code: MOON123</Text>
        </View>
        <TouchableOpacity onPress={handleShare} style={styles.shareButton}>
          <Text style={styles.shareIcon}>📤</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.statsContainer}>
        <View style={styles.statItem}>
          <Text style={styles.statValue}>#42</Text>
          <Text style={styles.statLabel}>Global Rank</Text>
        </View>
        <View style={styles.statItem}>
          <Text style={styles.statValue}>3</Text>
          <Text style={styles.statLabel}>Leagues</Text>
        </View>
        <View style={styles.statItem}>
          <Text style={styles.statValue}>12</Text>
          <Text style={styles.statLabel}>Referrals</Text>
        </View>
      </View>

      <View style={styles.tabContainer}>
        <TouchableOpacity
          style={[styles.tab, selectedTab === 'portfolio' && styles.tabActive]}
          onPress={() => setSelectedTab('portfolio')}>
          <Text style={[styles.tabText, selectedTab === 'portfolio' && styles.tabTextActive]}>
            Portfolio
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.tab, selectedTab === 'activity' && styles.tabActive]}
          onPress={() => setSelectedTab('activity')}>
          <Text style={[styles.tabText, selectedTab === 'activity' && styles.tabTextActive]}>
            Activity
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.tab, selectedTab === 'wallet' && styles.tabActive]}
          onPress={() => setSelectedTab('wallet')}>
          <Text style={[styles.tabText, selectedTab === 'wallet' && styles.tabTextActive]}>
            Wallet
          </Text>
        </TouchableOpacity>
      </View>

      {selectedTab === 'portfolio' && renderPortfolioTab()}
      {selectedTab === 'activity' && renderActivityTab()}
      {selectedTab === 'wallet' && renderWalletTab()}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
  },
  headerInfo: {
    flex: 1,
    marginLeft: 16,
  },
  username: {
    ...Typography.h3,
    color: Colors.text.primary,
  },
  inviteCode: {
    ...Typography.bodySmall,
    color: Colors.text.secondary,
  },
  shareButton: {
    padding: 8,
  },
  shareIcon: {
    fontSize: 24,
  },
  statsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    paddingVertical: 16,
    paddingHorizontal: 16,
  },
  statItem: {
    alignItems: 'center',
  },
  statValue: {
    ...Typography.h2,
    color: Colors.primary,
    fontWeight: '700',
  },
  statLabel: {
    ...Typography.caption,
    color: Colors.text.secondary,
    marginTop: 4,
  },
  tabContainer: {
    flexDirection: 'row',
    paddingHorizontal: 16,
    borderBottomWidth: 1,
    borderBottomColor: Colors.border,
  },
  tab: {
    flex: 1,
    paddingVertical: 12,
    alignItems: 'center',
  },
  tabActive: {
    borderBottomWidth: 2,
    borderBottomColor: Colors.primary,
  },
  tabText: {
    ...Typography.body,
    color: Colors.text.secondary,
  },
  tabTextActive: {
    color: Colors.primary,
    fontWeight: '600',
  },
  tabContent: {
    flex: 1,
    padding: 16,
  },
  portfolioCard: {
    padding: 0,
    overflow: 'hidden',
    marginBottom: 20,
  },
  portfolioGradient: {
    padding: 20,
  },
  portfolioLabel: {
    ...Typography.bodySmall,
    color: Colors.alpha.white50,
  },
  portfolioValue: {
    ...Typography.h1,
    color: Colors.text.primary,
    marginVertical: 8,
  },
  portfolioStats: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 16,
  },
  portfolioStat: {
    flex: 1,
  },
  portfolioStatLabel: {
    ...Typography.caption,
    color: Colors.alpha.white50,
  },
  portfolioStatValue: {
    ...Typography.body,
    fontWeight: '600',
    marginTop: 2,
  },
  sectionTitle: {
    ...Typography.h4,
    color: Colors.text.primary,
    marginBottom: 12,
  },
  positionCard: {
    marginBottom: 20,
    alignItems: 'center',
    paddingVertical: 24,
  },
  emptyText: {
    ...Typography.body,
    color: Colors.text.secondary,
    marginBottom: 12,
  },
  browseButton: {
    marginTop: 8,
  },
  rewardCard: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  rewardInfo: {
    flex: 1,
  },
  rewardType: {
    ...Typography.caption,
    color: Colors.warning,
    fontWeight: '600',
  },
  rewardDescription: {
    ...Typography.body,
    color: Colors.text.primary,
    marginVertical: 2,
  },
  rewardExpiry: {
    ...Typography.caption,
    color: Colors.text.tertiary,
  },
  rewardAction: {
    alignItems: 'flex-end',
  },
  rewardAmount: {
    ...Typography.body,
    color: Colors.success,
    fontWeight: '700',
    marginBottom: 8,
  },
  transactionCard: {
    marginBottom: 8,
  },
  transactionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  transactionIcon: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
  transactionIconText: {
    fontSize: 20,
  },
  transactionInfo: {
    flex: 1,
    marginLeft: 12,
  },
  transactionType: {
    ...Typography.body,
    color: Colors.text.primary,
    fontWeight: '600',
  },
  transactionDescription: {
    ...Typography.caption,
    color: Colors.text.secondary,
    marginVertical: 2,
  },
  transactionTime: {
    ...Typography.caption,
    color: Colors.text.tertiary,
  },
  transactionAmount: {
    alignItems: 'flex-end',
  },
  transactionAmountText: {
    ...Typography.body,
    fontWeight: '600',
  },
  statusBadge: {
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 8,
    marginTop: 4,
  },
  statusText: {
    ...Typography.caption,
    color: Colors.text.inverse,
    fontWeight: '600',
  },
  walletCard: {
    marginBottom: 16,
  },
  walletLabel: {
    ...Typography.caption,
    color: Colors.text.secondary,
    marginBottom: 8,
  },
  walletAddress: {
    ...Typography.mono,
    color: Colors.text.primary,
    marginBottom: 12,
  },
  walletButton: {
    alignSelf: 'flex-start',
  },
  balanceCard: {
    marginBottom: 16,
  },
  balanceLabel: {
    ...Typography.caption,
    color: Colors.text.secondary,
    marginBottom: 8,
  },
  balanceAmount: {
    ...Typography.h2,
    color: Colors.text.primary,
    marginBottom: 16,
  },
  balanceActions: {
    flexDirection: 'row',
  },
  balanceButton: {
    flex: 1,
    marginHorizontal: 4,
  },
  securityCard: {
    marginBottom: 16,
  },
  securityTitle: {
    ...Typography.h4,
    color: Colors.text.primary,
    marginBottom: 12,
  },
  securityItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 12,
    borderTopWidth: 1,
    borderTopColor: Colors.border,
  },
  securityItemText: {
    ...Typography.body,
    color: Colors.text.primary,
  },
  securityItemIcon: {
    ...Typography.body,
    color: Colors.text.secondary,
  },
  dangerCard: {
    borderColor: Colors.danger,
    borderWidth: 1,
  },
  dangerTitle: {
    ...Typography.body,
    color: Colors.danger,
    marginBottom: 12,
  },
});