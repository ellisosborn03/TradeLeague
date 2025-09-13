import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  FlatList,
  TouchableOpacity,
  RefreshControl,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import { Colors } from '../constants/colors';
import { Typography } from '../constants/typography';
import { Card } from '../components/Card';
import { Avatar } from '../components/Avatar';
import { Button } from '../components/Button';
import { LeagueParticipant, League } from '../types';

const mockLeaderboard: LeagueParticipant[] = [
  {
    userId: '1',
    user: {
      id: '1',
      username: '@whale',
      walletAddress: '0x123...',
      totalVolume: 125000,
      inviteCode: 'WHALE123',
      createdAt: new Date(),
      currentScore: 342,
      rank: 1,
    },
    joinedAt: new Date(),
    currentScore: 342,
    rank: 1,
    percentageGain: 342,
  },
  {
    userId: '2',
    user: {
      id: '2',
      username: '@degen',
      walletAddress: '0x456...',
      totalVolume: 98000,
      inviteCode: 'DEGEN456',
      createdAt: new Date(),
      currentScore: 287,
      rank: 2,
    },
    joinedAt: new Date(),
    currentScore: 287,
    rank: 2,
    percentageGain: 287,
  },
  {
    userId: '3',
    user: {
      id: '3',
      username: '@trader',
      walletAddress: '0x789...',
      totalVolume: 76000,
      inviteCode: 'TRADE789',
      createdAt: new Date(),
      currentScore: 198,
      rank: 3,
    },
    joinedAt: new Date(),
    currentScore: 198,
    rank: 3,
    percentageGain: 198,
  },
];

const mockLeagues: League[] = [
  {
    id: '1',
    name: 'Circle League',
    creatorId: 'circle',
    entryFee: 0,
    prizePool: 10000,
    startTime: new Date(),
    endTime: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
    isPublic: true,
    maxParticipants: 1000,
    participants: [],
    sponsorName: 'Circle',
    sponsorLogo: '⭕',
  },
  {
    id: '2',
    name: 'Hyperion Week',
    creatorId: 'hyperion',
    entryFee: 100,
    prizePool: 5000,
    startTime: new Date(),
    endTime: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
    isPublic: true,
    maxParticipants: 500,
    participants: [],
    sponsorName: 'Hyperion',
    sponsorLogo: '🌟',
  },
];

export const LeagueScreen = () => {
  const [refreshing, setRefreshing] = useState(false);
  const [selectedTab, setSelectedTab] = useState<'global' | 'leagues'>('global');

  const onRefresh = () => {
    setRefreshing(true);
    setTimeout(() => setRefreshing(false), 2000);
  };

  const renderLeaderboardItem = ({ item, index }: { item: LeagueParticipant; index: number }) => {
    const isTop3 = index < 3;
    
    return (
      <Card style={styles.leaderboardItem} variant={isTop3 ? 'elevated' : 'default'}>
        <View style={styles.leaderboardRow}>
          <View style={styles.rankContainer}>
            <Text style={[styles.rank, isTop3 && styles.rankTop3]}>
              {item.rank}
            </Text>
          </View>
          <Avatar
            name={item.user.username}
            size="medium"
            showBorder={isTop3}
            rank={isTop3 ? item.rank : undefined}
          />
          <View style={styles.userInfo}>
            <Text style={styles.username}>{item.user.username}</Text>
            <Text style={styles.score}>Score: {item.currentScore}</Text>
          </View>
          <View style={styles.gainContainer}>
            <Text style={[styles.gain, { color: Colors.success }]}>
              +{item.percentageGain}%
            </Text>
            {isTop3 && <Text style={styles.trophy}>🏆</Text>}
          </View>
        </View>
      </Card>
    );
  };

  const renderLeagueItem = ({ item }: { item: League }) => (
    <Card style={styles.leagueCard} onPress={() => {}}>
      <LinearGradient
        colors={Colors.gradients.dark}
        style={styles.leagueGradient}>
        <View style={styles.leagueHeader}>
          <Text style={styles.sponsorLogo}>{item.sponsorLogo}</Text>
          <View style={styles.leagueInfo}>
            <Text style={styles.leagueName}>{item.name}</Text>
            <Text style={styles.leagueSponsor}>by {item.sponsorName}</Text>
          </View>
          <View style={styles.prizeContainer}>
            <Text style={styles.prizeLabel}>Prize Pool</Text>
            <Text style={styles.prizeAmount}>${item.prizePool.toLocaleString()}</Text>
          </View>
        </View>
        <View style={styles.leagueFooter}>
          <Text style={styles.leagueDetail}>
            Entry: {item.entryFee === 0 ? 'Free' : `${item.entryFee} USDC`}
          </Text>
          <Text style={styles.leagueDetail}>
            {item.participants.length}/{item.maxParticipants} players
          </Text>
          <Button
            title="Join"
            onPress={() => {}}
            size="small"
            variant="primary"
          />
        </View>
      </LinearGradient>
    </Card>
  );

  return (
    <View style={styles.container}>
      <View style={styles.tabContainer}>
        <TouchableOpacity
          style={[styles.tab, selectedTab === 'global' && styles.tabActive]}
          onPress={() => setSelectedTab('global')}>
          <Text style={[styles.tabText, selectedTab === 'global' && styles.tabTextActive]}>
            Global Leaderboard
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.tab, selectedTab === 'leagues' && styles.tabActive]}
          onPress={() => setSelectedTab('leagues')}>
          <Text style={[styles.tabText, selectedTab === 'leagues' && styles.tabTextActive]}>
            Leagues
          </Text>
        </TouchableOpacity>
      </View>

      {selectedTab === 'global' ? (
        <FlatList
          data={mockLeaderboard}
          renderItem={renderLeaderboardItem}
          keyExtractor={item => item.userId}
          contentContainerStyle={styles.listContent}
          refreshControl={
            <RefreshControl
              refreshing={refreshing}
              onRefresh={onRefresh}
              tintColor={Colors.primary}
            />
          }
          ListHeaderComponent={
            <View style={styles.headerContainer}>
              <Text style={styles.headerTitle}>Top Traders</Text>
              <Text style={styles.headerSubtitle}>Compete for weekly prizes</Text>
            </View>
          }
        />
      ) : (
        <FlatList
          data={mockLeagues}
          renderItem={renderLeagueItem}
          keyExtractor={item => item.id}
          contentContainerStyle={styles.listContent}
          refreshControl={
            <RefreshControl
              refreshing={refreshing}
              onRefresh={onRefresh}
              tintColor={Colors.primary}
            />
          }
          ListHeaderComponent={
            <View style={styles.headerContainer}>
              <Text style={styles.headerTitle}>Active Leagues</Text>
              <Button
                title="Create League"
                onPress={() => {}}
                size="small"
                variant="outline"
                style={styles.createButton}
              />
            </View>
          }
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  tabContainer: {
    flexDirection: 'row',
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  tab: {
    flex: 1,
    paddingVertical: 12,
    alignItems: 'center',
    borderBottomWidth: 2,
    borderBottomColor: 'transparent',
  },
  tabActive: {
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
  listContent: {
    paddingHorizontal: 16,
    paddingBottom: 100,
  },
  headerContainer: {
    marginVertical: 16,
  },
  headerTitle: {
    ...Typography.h2,
    color: Colors.text.primary,
    marginBottom: 4,
  },
  headerSubtitle: {
    ...Typography.body,
    color: Colors.text.secondary,
  },
  createButton: {
    marginTop: 12,
    alignSelf: 'flex-start',
  },
  leaderboardItem: {
    marginVertical: 4,
  },
  leaderboardRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  rankContainer: {
    width: 30,
    marginRight: 12,
  },
  rank: {
    ...Typography.h4,
    color: Colors.text.secondary,
    textAlign: 'center',
  },
  rankTop3: {
    color: Colors.warning,
    fontWeight: '700',
  },
  userInfo: {
    flex: 1,
    marginLeft: 12,
  },
  username: {
    ...Typography.body,
    color: Colors.text.primary,
    fontWeight: '600',
  },
  score: {
    ...Typography.caption,
    color: Colors.text.secondary,
  },
  gainContainer: {
    alignItems: 'flex-end',
  },
  gain: {
    ...Typography.body,
    fontWeight: '600',
  },
  trophy: {
    fontSize: 20,
    marginTop: 4,
  },
  leagueCard: {
    marginVertical: 8,
    padding: 0,
    overflow: 'hidden',
  },
  leagueGradient: {
    padding: 16,
  },
  leagueHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  sponsorLogo: {
    fontSize: 32,
    marginRight: 12,
  },
  leagueInfo: {
    flex: 1,
  },
  leagueName: {
    ...Typography.h4,
    color: Colors.text.primary,
  },
  leagueSponsor: {
    ...Typography.caption,
    color: Colors.text.secondary,
  },
  prizeContainer: {
    alignItems: 'flex-end',
  },
  prizeLabel: {
    ...Typography.caption,
    color: Colors.text.secondary,
  },
  prizeAmount: {
    ...Typography.h4,
    color: Colors.success,
    fontWeight: '700',
  },
  leagueFooter: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  leagueDetail: {
    ...Typography.caption,
    color: Colors.text.secondary,
  },
});