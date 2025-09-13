import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  RefreshControl,
  Modal,
  ScrollView,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import { Colors } from '../constants/colors';
import { Typography } from '../constants/typography';
import { Card } from '../components/Card';
import { Button } from '../components/Button';
import { Input } from '../components/Input';
import { Avatar } from '../components/Avatar';
import { Vault } from '../types';

const mockVaults: Vault[] = [
  {
    id: '1',
    managerId: '1',
    manager: {
      id: '1',
      username: '@defi_wizard',
      walletAddress: '0x123...',
      totalVolume: 500000,
      inviteCode: 'WIZARD',
      createdAt: new Date(),
      currentScore: 450,
    },
    name: 'Yield Maximizer',
    strategy: 'Yield Farming',
    venue: 'Hyperion',
    totalAUM: 245000,
    performanceFee: 10,
    allTimeReturn: 127,
    weeklyReturn: 12,
    monthlyReturn: 45,
    followers: 234,
    description: 'Automated yield farming across multiple protocols',
    riskLevel: 'Moderate',
  },
  {
    id: '2',
    managerId: '2',
    manager: {
      id: '2',
      username: '@perps_master',
      walletAddress: '0x456...',
      totalVolume: 750000,
      inviteCode: 'PERPS',
      createdAt: new Date(),
      currentScore: 380,
    },
    name: 'Perps Alpha',
    strategy: 'Perps Trading',
    venue: 'Merkle',
    totalAUM: 189000,
    performanceFee: 15,
    allTimeReturn: 89,
    weeklyReturn: -5,
    monthlyReturn: 23,
    followers: 156,
    description: 'High-frequency perpetual futures trading',
    riskLevel: 'Aggressive',
  },
  {
    id: '3',
    managerId: '3',
    manager: {
      id: '3',
      username: '@arb_bot',
      walletAddress: '0x789...',
      totalVolume: 320000,
      inviteCode: 'ARB',
      createdAt: new Date(),
      currentScore: 290,
    },
    name: 'Arbitrage Pro',
    strategy: 'Arbitrage',
    venue: 'Tapp',
    totalAUM: 156000,
    performanceFee: 12,
    allTimeReturn: 67,
    weeklyReturn: 8,
    monthlyReturn: 28,
    followers: 189,
    description: 'Cross-DEX arbitrage opportunities',
    riskLevel: 'Conservative',
  },
];

export const TradeScreen = () => {
  const [refreshing, setRefreshing] = useState(false);
  const [selectedVault, setSelectedVault] = useState<Vault | null>(null);
  const [followAmount, setFollowAmount] = useState('100');
  const [filterVenue, setFilterVenue] = useState<string>('All');

  const onRefresh = () => {
    setRefreshing(true);
    setTimeout(() => setRefreshing(false), 2000);
  };

  const getStrategyColor = (strategy: string) => {
    switch (strategy) {
      case 'Yield Farming':
        return Colors.success;
      case 'Perps Trading':
        return Colors.warning;
      case 'Arbitrage':
        return Colors.info;
      default:
        return Colors.primary;
    }
  };

  const getRiskColor = (risk: string) => {
    switch (risk) {
      case 'Conservative':
        return Colors.success;
      case 'Moderate':
        return Colors.warning;
      case 'Aggressive':
        return Colors.danger;
      default:
        return Colors.text.secondary;
    }
  };

  const filteredVaults = filterVenue === 'All' 
    ? mockVaults 
    : mockVaults.filter(v => v.venue === filterVenue);

  const renderVaultItem = ({ item }: { item: Vault }) => (
    <Card style={styles.vaultCard} onPress={() => setSelectedVault(item)}>
      <View style={styles.vaultHeader}>
        <Avatar name={item.manager.username} size="medium" />
        <View style={styles.vaultInfo}>
          <Text style={styles.vaultName}>{item.name}</Text>
          <View style={styles.vaultMeta}>
            <Text style={[styles.strategy, { color: getStrategyColor(item.strategy) }]}>
              {item.strategy}
            </Text>
            <Text style={styles.venue}>{item.venue}</Text>
          </View>
        </View>
        <View style={styles.vaultStats}>
          <Text style={styles.aum}>${(item.totalAUM / 1000).toFixed(0)}K AUM</Text>
          <Text style={[styles.risk, { color: getRiskColor(item.riskLevel) }]}>
            {item.riskLevel}
          </Text>
        </View>
      </View>
      
      <View style={styles.performanceContainer}>
        <View style={styles.performanceItem}>
          <Text style={styles.performanceLabel}>7D</Text>
          <Text style={[
            styles.performanceValue,
            { color: item.weeklyReturn >= 0 ? Colors.success : Colors.danger }
          ]}>
            {item.weeklyReturn >= 0 ? '+' : ''}{item.weeklyReturn}%
          </Text>
        </View>
        <View style={styles.performanceItem}>
          <Text style={styles.performanceLabel}>30D</Text>
          <Text style={[
            styles.performanceValue,
            { color: item.monthlyReturn >= 0 ? Colors.success : Colors.danger }
          ]}>
            {item.monthlyReturn >= 0 ? '+' : ''}{item.monthlyReturn}%
          </Text>
        </View>
        <View style={styles.performanceItem}>
          <Text style={styles.performanceLabel}>All-Time</Text>
          <Text style={[
            styles.performanceValue,
            { color: item.allTimeReturn >= 0 ? Colors.success : Colors.danger }
          ]}>
            {item.allTimeReturn >= 0 ? '+' : ''}{item.allTimeReturn}%
          </Text>
        </View>
      </View>

      <View style={styles.vaultFooter}>
        <Text style={styles.followers}>{item.followers} followers</Text>
        <Text style={styles.fee}>{item.performanceFee}% fee</Text>
        <Button
          title="Follow"
          onPress={() => setSelectedVault(item)}
          size="small"
          variant="primary"
        />
      </View>
    </Card>
  );

  return (
    <View style={styles.container}>
      <View style={styles.filterContainer}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          {['All', 'Hyperion', 'Merkle', 'Tapp'].map(venue => (
            <TouchableOpacity
              key={venue}
              style={[styles.filterChip, filterVenue === venue && styles.filterChipActive]}
              onPress={() => setFilterVenue(venue)}>
              <Text style={[
                styles.filterText,
                filterVenue === venue && styles.filterTextActive
              ]}>
                {venue}
              </Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>

      <FlatList
        data={filteredVaults}
        renderItem={renderVaultItem}
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
            <Text style={styles.headerTitle}>Top Vaults</Text>
            <Text style={styles.headerSubtitle}>Copy trade successful strategies</Text>
          </View>
        }
      />

      <Modal
        visible={selectedVault !== null}
        animationType="slide"
        transparent={true}
        onRequestClose={() => setSelectedVault(null)}>
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            {selectedVault && (
              <>
                <View style={styles.modalHeader}>
                  <Text style={styles.modalTitle}>Follow Vault</Text>
                  <TouchableOpacity onPress={() => setSelectedVault(null)}>
                    <Text style={styles.closeButton}>✕</Text>
                  </TouchableOpacity>
                </View>

                <Card style={styles.modalVaultInfo}>
                  <Text style={styles.modalVaultName}>{selectedVault.name}</Text>
                  <Text style={styles.modalDescription}>{selectedVault.description}</Text>
                  
                  <View style={styles.modalStats}>
                    <View style={styles.modalStatItem}>
                      <Text style={styles.modalStatLabel}>Manager</Text>
                      <Text style={styles.modalStatValue}>{selectedVault.manager.username}</Text>
                    </View>
                    <View style={styles.modalStatItem}>
                      <Text style={styles.modalStatLabel}>Total AUM</Text>
                      <Text style={styles.modalStatValue}>
                        ${selectedVault.totalAUM.toLocaleString()}
                      </Text>
                    </View>
                    <View style={styles.modalStatItem}>
                      <Text style={styles.modalStatLabel}>Performance Fee</Text>
                      <Text style={styles.modalStatValue}>{selectedVault.performanceFee}%</Text>
                    </View>
                  </View>
                </Card>

                <Input
                  label="Amount to Invest (USDC)"
                  value={followAmount}
                  onChangeText={setFollowAmount}
                  keyboardType="numeric"
                  placeholder="Min 10 USDC"
                />

                <View style={styles.modalActions}>
                  <Button
                    title="Cancel"
                    onPress={() => setSelectedVault(null)}
                    variant="outline"
                    style={styles.modalButton}
                  />
                  <Button
                    title={`Follow with ${followAmount} USDC`}
                    onPress={() => {
                      setSelectedVault(null);
                    }}
                    variant="primary"
                    style={styles.modalButton}
                  />
                </View>
              </>
            )}
          </View>
        </View>
      </Modal>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  filterContainer: {
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  filterChip: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 20,
    backgroundColor: Colors.surface,
    marginRight: 8,
  },
  filterChipActive: {
    backgroundColor: Colors.primary,
  },
  filterText: {
    ...Typography.bodySmall,
    color: Colors.text.secondary,
  },
  filterTextActive: {
    color: Colors.text.primary,
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
  vaultCard: {
    marginVertical: 8,
  },
  vaultHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  vaultInfo: {
    flex: 1,
    marginLeft: 12,
  },
  vaultName: {
    ...Typography.h4,
    color: Colors.text.primary,
  },
  vaultMeta: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 2,
  },
  strategy: {
    ...Typography.caption,
    fontWeight: '600',
    marginRight: 8,
  },
  venue: {
    ...Typography.caption,
    color: Colors.text.secondary,
  },
  vaultStats: {
    alignItems: 'flex-end',
  },
  aum: {
    ...Typography.bodySmall,
    color: Colors.text.primary,
    fontWeight: '600',
  },
  risk: {
    ...Typography.caption,
    fontWeight: '600',
    marginTop: 2,
  },
  performanceContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    paddingVertical: 12,
    borderTopWidth: 1,
    borderBottomWidth: 1,
    borderColor: Colors.border,
  },
  performanceItem: {
    alignItems: 'center',
  },
  performanceLabel: {
    ...Typography.caption,
    color: Colors.text.secondary,
  },
  performanceValue: {
    ...Typography.body,
    fontWeight: '700',
    marginTop: 2,
  },
  vaultFooter: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginTop: 12,
  },
  followers: {
    ...Typography.caption,
    color: Colors.text.secondary,
  },
  fee: {
    ...Typography.caption,
    color: Colors.text.secondary,
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: Colors.alpha.black50,
    justifyContent: 'flex-end',
  },
  modalContent: {
    backgroundColor: Colors.background,
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    padding: 24,
    paddingBottom: 40,
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  modalTitle: {
    ...Typography.h3,
    color: Colors.text.primary,
  },
  closeButton: {
    fontSize: 24,
    color: Colors.text.secondary,
  },
  modalVaultInfo: {
    marginBottom: 20,
  },
  modalVaultName: {
    ...Typography.h4,
    color: Colors.text.primary,
    marginBottom: 8,
  },
  modalDescription: {
    ...Typography.body,
    color: Colors.text.secondary,
    marginBottom: 16,
  },
  modalStats: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  modalStatItem: {
    flex: 1,
  },
  modalStatLabel: {
    ...Typography.caption,
    color: Colors.text.secondary,
  },
  modalStatValue: {
    ...Typography.bodySmall,
    color: Colors.text.primary,
    fontWeight: '600',
    marginTop: 2,
  },
  modalActions: {
    flexDirection: 'row',
    marginTop: 20,
  },
  modalButton: {
    flex: 1,
    marginHorizontal: 4,
  },
});