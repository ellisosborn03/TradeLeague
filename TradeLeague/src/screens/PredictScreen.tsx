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
import { PredictionMarket, PredictionOutcome } from '../types';

const mockMarkets: PredictionMarket[] = [
  {
    id: '1',
    sponsor: 'Panora',
    sponsorLogo: '📊',
    question: 'Will APT be above $20 by Friday?',
    outcomes: [
      { index: 0, label: 'Yes', probability: 67, totalStaked: 45200, color: Colors.success },
      { index: 1, label: 'No', probability: 33, totalStaked: 22100, color: Colors.danger },
    ],
    totalStaked: 67300,
    resolutionTime: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000),
    resolved: false,
    marketType: 'Binary',
    category: 'Price',
  },
  {
    id: '2',
    sponsor: 'Kana Labs',
    sponsorLogo: '🌉',
    question: 'Which chain will have more volume this week?',
    outcomes: [
      { index: 0, label: 'Aptos', probability: 45, totalStaked: 34500, color: Colors.primary },
      { index: 1, label: 'Ethereum', probability: 35, totalStaked: 26800, color: Colors.info },
      { index: 2, label: 'Solana', probability: 20, totalStaked: 15300, color: Colors.warning },
    ],
    totalStaked: 76600,
    resolutionTime: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
    resolved: false,
    marketType: 'Multiple',
    category: 'CrossChain',
  },
  {
    id: '3',
    sponsor: 'Ekiden',
    sponsorLogo: '📈',
    question: 'BTC Dec 31 Futures Settlement Range?',
    outcomes: [
      { index: 0, label: 'Below $95K', probability: 25, totalStaked: 12500, color: Colors.danger },
      { index: 1, label: '$95K-$105K', probability: 50, totalStaked: 25000, color: Colors.warning },
      { index: 2, label: 'Above $105K', probability: 25, totalStaked: 12500, color: Colors.success },
    ],
    totalStaked: 50000,
    resolutionTime: new Date(Date.now() + 14 * 24 * 60 * 60 * 1000),
    resolved: false,
    marketType: 'Multiple',
    category: 'Derivatives',
  },
];

export const PredictScreen = () => {
  const [refreshing, setRefreshing] = useState(false);
  const [selectedMarket, setSelectedMarket] = useState<PredictionMarket | null>(null);
  const [selectedOutcome, setSelectedOutcome] = useState<number | null>(null);
  const [stakeAmount, setStakeAmount] = useState('10');
  const [filterCategory, setFilterCategory] = useState<string>('All');

  const onRefresh = () => {
    setRefreshing(true);
    setTimeout(() => setRefreshing(false), 2000);
  };

  const calculatePotentialPayout = (stake: number, outcome: PredictionOutcome, market: PredictionMarket) => {
    const totalPool = market.totalStaked + stake;
    const outcomePool = outcome.totalStaked + stake;
    return (totalPool / outcomePool) * stake;
  };

  const getTimeRemaining = (endTime: Date) => {
    const now = new Date();
    const diff = endTime.getTime() - now.getTime();
    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
    const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    
    if (days > 0) {
      return `${days}d ${hours}h`;
    }
    return `${hours}h`;
  };

  const filteredMarkets = filterCategory === 'All'
    ? mockMarkets
    : mockMarkets.filter(m => m.category === filterCategory);

  const renderMarketItem = ({ item }: { item: PredictionMarket }) => (
    <Card style={styles.marketCard} onPress={() => setSelectedMarket(item)}>
      <View style={styles.marketHeader}>
        <View style={styles.sponsorBadge}>
          <Text style={styles.sponsorLogo}>{item.sponsorLogo}</Text>
          <Text style={styles.sponsorName}>{item.sponsor}</Text>
        </View>
        <View style={styles.timeContainer}>
          <Text style={styles.timeLabel}>Ends in</Text>
          <Text style={styles.timeValue}>{getTimeRemaining(item.resolutionTime)}</Text>
        </View>
      </View>

      <Text style={styles.question}>{item.question}</Text>

      <View style={styles.outcomesContainer}>
        {item.outcomes.map((outcome) => (
          <View key={outcome.index} style={styles.outcomeRow}>
            <View style={styles.outcomeInfo}>
              <View style={[styles.outcomeIndicator, { backgroundColor: outcome.color }]} />
              <Text style={styles.outcomeLabel}>{outcome.label}</Text>
            </View>
            <Text style={styles.outcomeProbability}>{outcome.probability}%</Text>
          </View>
        ))}
      </View>

      <View style={styles.marketFooter}>
        <Text style={styles.totalStaked}>
          ${(item.totalStaked / 1000).toFixed(1)}K staked
        </Text>
        <Button
          title="Predict"
          onPress={() => setSelectedMarket(item)}
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
          {['All', 'Price', 'CrossChain', 'Derivatives', 'Volume'].map(category => (
            <TouchableOpacity
              key={category}
              style={[styles.filterChip, filterCategory === category && styles.filterChipActive]}
              onPress={() => setFilterCategory(category)}>
              <Text style={[
                styles.filterText,
                filterCategory === category && styles.filterTextActive
              ]}>
                {category}
              </Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>

      <FlatList
        data={filteredMarkets}
        renderItem={renderMarketItem}
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
            <Text style={styles.headerTitle}>Active Predictions</Text>
            <Text style={styles.headerSubtitle}>Sponsored by ecosystem partners</Text>
          </View>
        }
      />

      <Modal
        visible={selectedMarket !== null}
        animationType="slide"
        transparent={true}
        onRequestClose={() => {
          setSelectedMarket(null);
          setSelectedOutcome(null);
        }}>
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            {selectedMarket && (
              <>
                <View style={styles.modalHeader}>
                  <Text style={styles.modalTitle}>Place Prediction</Text>
                  <TouchableOpacity onPress={() => {
                    setSelectedMarket(null);
                    setSelectedOutcome(null);
                  }}>
                    <Text style={styles.closeButton}>✕</Text>
                  </TouchableOpacity>
                </View>

                <Card style={styles.modalMarketInfo}>
                  <View style={styles.modalSponsor}>
                    <Text style={styles.modalSponsorLogo}>{selectedMarket.sponsorLogo}</Text>
                    <Text style={styles.modalSponsorName}>{selectedMarket.sponsor}</Text>
                  </View>
                  <Text style={styles.modalQuestion}>{selectedMarket.question}</Text>
                  <Text style={styles.modalEndTime}>
                    Resolves in {getTimeRemaining(selectedMarket.resolutionTime)}
                  </Text>
                </Card>

                <Text style={styles.outcomeSelectLabel}>Select Outcome</Text>
                <View style={styles.outcomeOptions}>
                  {selectedMarket.outcomes.map((outcome) => (
                    <TouchableOpacity
                      key={outcome.index}
                      style={[
                        styles.outcomeOption,
                        selectedOutcome === outcome.index && styles.outcomeOptionSelected
                      ]}
                      onPress={() => setSelectedOutcome(outcome.index)}>
                      <View style={[styles.outcomeIndicator, { backgroundColor: outcome.color }]} />
                      <Text style={styles.outcomeOptionLabel}>{outcome.label}</Text>
                      <Text style={styles.outcomeOptionProbability}>{outcome.probability}%</Text>
                    </TouchableOpacity>
                  ))}
                </View>

                <Input
                  label="Stake Amount (USDC)"
                  value={stakeAmount}
                  onChangeText={setStakeAmount}
                  keyboardType="numeric"
                  placeholder="Min 5 USDC"
                />

                {selectedOutcome !== null && stakeAmount && (
                  <Card style={styles.payoutCard} variant="outlined">
                    <Text style={styles.payoutLabel}>Potential Payout</Text>
                    <Text style={styles.payoutAmount}>
                      {calculatePotentialPayout(
                        parseFloat(stakeAmount) || 0,
                        selectedMarket.outcomes[selectedOutcome],
                        selectedMarket
                      ).toFixed(2)} USDC
                    </Text>
                  </Card>
                )}

                <View style={styles.modalActions}>
                  <Button
                    title="Cancel"
                    onPress={() => {
                      setSelectedMarket(null);
                      setSelectedOutcome(null);
                    }}
                    variant="outline"
                    style={styles.modalButton}
                  />
                  <Button
                    title={`Predict with ${stakeAmount} USDC`}
                    onPress={() => {
                      setSelectedMarket(null);
                      setSelectedOutcome(null);
                    }}
                    variant="primary"
                    style={styles.modalButton}
                    disabled={selectedOutcome === null}
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
  marketCard: {
    marginVertical: 8,
  },
  marketHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  sponsorBadge: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  sponsorLogo: {
    fontSize: 20,
    marginRight: 8,
  },
  sponsorName: {
    ...Typography.bodySmall,
    color: Colors.text.secondary,
    fontWeight: '600',
  },
  timeContainer: {
    alignItems: 'flex-end',
  },
  timeLabel: {
    ...Typography.caption,
    color: Colors.text.tertiary,
  },
  timeValue: {
    ...Typography.bodySmall,
    color: Colors.warning,
    fontWeight: '600',
  },
  question: {
    ...Typography.h4,
    color: Colors.text.primary,
    marginBottom: 16,
  },
  outcomesContainer: {
    marginBottom: 16,
  },
  outcomeRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginVertical: 4,
  },
  outcomeInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  outcomeIndicator: {
    width: 12,
    height: 12,
    borderRadius: 6,
    marginRight: 8,
  },
  outcomeLabel: {
    ...Typography.body,
    color: Colors.text.primary,
  },
  outcomeProbability: {
    ...Typography.body,
    color: Colors.text.secondary,
    fontWeight: '600',
  },
  marketFooter: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingTop: 12,
    borderTopWidth: 1,
    borderTopColor: Colors.border,
  },
  totalStaked: {
    ...Typography.bodySmall,
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
  modalMarketInfo: {
    marginBottom: 20,
  },
  modalSponsor: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  modalSponsorLogo: {
    fontSize: 24,
    marginRight: 8,
  },
  modalSponsorName: {
    ...Typography.body,
    color: Colors.text.secondary,
  },
  modalQuestion: {
    ...Typography.h4,
    color: Colors.text.primary,
    marginBottom: 8,
  },
  modalEndTime: {
    ...Typography.caption,
    color: Colors.warning,
  },
  outcomeSelectLabel: {
    ...Typography.bodySmall,
    color: Colors.text.secondary,
    marginBottom: 8,
  },
  outcomeOptions: {
    marginBottom: 20,
  },
  outcomeOption: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 12,
    borderRadius: 12,
    backgroundColor: Colors.surface,
    marginVertical: 4,
  },
  outcomeOptionSelected: {
    backgroundColor: Colors.surfaceLight,
    borderWidth: 1,
    borderColor: Colors.primary,
  },
  outcomeOptionLabel: {
    ...Typography.body,
    color: Colors.text.primary,
    flex: 1,
    marginLeft: 8,
  },
  outcomeOptionProbability: {
    ...Typography.body,
    color: Colors.text.secondary,
    fontWeight: '600',
  },
  payoutCard: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  payoutLabel: {
    ...Typography.body,
    color: Colors.text.secondary,
  },
  payoutAmount: {
    ...Typography.h4,
    color: Colors.success,
    fontWeight: '700',
  },
  modalActions: {
    flexDirection: 'row',
  },
  modalButton: {
    flex: 1,
    marginHorizontal: 4,
  },
});