import { 
  Aptos, 
  AptosConfig, 
  Network,
  Account,
  Ed25519PrivateKey,
  TransactionPayloadEntryFunction,
} from '@aptos-labs/ts-sdk';

export class AptosService {
  private aptos: Aptos;
  private config: AptosConfig;

  constructor() {
    // Initialize Aptos SDK for testnet
    this.config = new AptosConfig({ 
      network: Network.TESTNET,
      fullnode: 'https://fullnode.testnet.aptoslabs.com/v1',
      indexer: 'https://indexer-testnet.staging.gcp.aptosdev.com/v1/graphql',
    });
    this.aptos = new Aptos(this.config);
  }

  // Account Management
  async createAccount(): Promise<Account> {
    return Account.generate();
  }

  async getAccount(address: string) {
    try {
      return await this.aptos.getAccountInfo({ accountAddress: address });
    } catch (error) {
      console.error('Error getting account:', error);
      throw error;
    }
  }

  async getAccountBalance(address: string): Promise<number> {
    try {
      const resources = await this.aptos.getAccountResources({
        accountAddress: address,
      });
      
      const coinResource = resources.find(
        resource => resource.type === '0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>'
      );
      
      if (coinResource) {
        return parseInt((coinResource.data as any).coin.value) / 100000000; // Convert from octas
      }
      return 0;
    } catch (error) {
      console.error('Error getting balance:', error);
      return 0;
    }
  }

  // Transaction Building and Submission
  async buildTransaction(
    sender: Account,
    payload: TransactionPayloadEntryFunction
  ) {
    return await this.aptos.transaction.build.simple({
      sender: sender.accountAddress.toString(),
      data: payload,
    });
  }

  async signAndSubmitTransaction(sender: Account, transaction: any) {
    const signedTransaction = await this.aptos.transaction.sign({
      signer: sender,
      transaction,
    });

    return await this.aptos.transaction.submit.simple({
      transaction: signedTransaction,
    });
  }

  // League Registry Smart Contract Interactions
  async createLeague(
    account: Account,
    name: string,
    entryFee: number,
    duration: number,
    isPublic: boolean,
    maxParticipants: number
  ) {
    const payload: TransactionPayloadEntryFunction = {
      function: '0x1::tradeleague_league_registry::create_league',
      functionArguments: [
        name,
        entryFee,
        duration,
        isPublic,
        maxParticipants,
      ],
    };

    const transaction = await this.buildTransaction(account, payload);
    return await this.signAndSubmitTransaction(account, transaction);
  }

  async joinLeague(account: Account, leagueId: string) {
    const payload: TransactionPayloadEntryFunction = {
      function: '0x1::tradeleague_league_registry::join_league',
      functionArguments: [leagueId],
    };

    const transaction = await this.buildTransaction(account, payload);
    return await this.signAndSubmitTransaction(account, transaction);
  }

  async getLeaderboard(leagueId: string) {
    try {
      // Query events for league updates
      const events = await this.aptos.getAccountEventsByEventType({
        accountAddress: '0x1', // Module address
        eventType: '0x1::tradeleague_league_registry::LeaderboardUpdateEvent',
      });

      return events.filter((event: any) => event.data.league_id === leagueId);
    } catch (error) {
      console.error('Error getting leaderboard:', error);
      return [];
    }
  }

  // Vault Manager Smart Contract Interactions
  async createVault(
    account: Account,
    strategy: string,
    venue: string,
    performanceFee: number
  ) {
    const payload: TransactionPayloadEntryFunction = {
      function: '0x1::tradeleague_vault_manager::create_vault',
      functionArguments: [strategy, venue, performanceFee],
    };

    const transaction = await this.buildTransaction(account, payload);
    return await this.signAndSubmitTransaction(account, transaction);
  }

  async followVault(account: Account, vaultId: string, amount: number) {
    const payload: TransactionPayloadEntryFunction = {
      function: '0x1::tradeleague_vault_manager::follow_vault',
      functionArguments: [vaultId, amount],
    };

    const transaction = await this.buildTransaction(account, payload);
    return await this.signAndSubmitTransaction(account, transaction);
  }

  async unfollowVault(account: Account, vaultId: string) {
    const payload: TransactionPayloadEntryFunction = {
      function: '0x1::tradeleague_vault_manager::unfollow_vault',
      functionArguments: [vaultId],
    };

    const transaction = await this.buildTransaction(account, payload);
    return await this.signAndSubmitTransaction(account, transaction);
  }

  // Prediction Market Smart Contract Interactions
  async createPredictionMarket(
    account: Account,
    question: string,
    outcomes: string[],
    resolutionTime: number
  ) {
    const payload: TransactionPayloadEntryFunction = {
      function: '0x1::tradeleague_prediction_market::create_market',
      functionArguments: [question, outcomes, resolutionTime],
    };

    const transaction = await this.buildTransaction(account, payload);
    return await this.signAndSubmitTransaction(account, transaction);
  }

  async placePrediction(
    account: Account,
    marketId: string,
    outcomeIndex: number,
    amount: number
  ) {
    const payload: TransactionPayloadEntryFunction = {
      function: '0x1::tradeleague_prediction_market::place_prediction',
      functionArguments: [marketId, outcomeIndex, amount],
    };

    const transaction = await this.buildTransaction(account, payload);
    return await this.signAndSubmitTransaction(account, transaction);
  }

  async settlePredictionMarket(
    account: Account,
    marketId: string,
    winningOutcome: number
  ) {
    const payload: TransactionPayloadEntryFunction = {
      function: '0x1::tradeleague_prediction_market::settle_market',
      functionArguments: [marketId, winningOutcome],
    };

    const transaction = await this.buildTransaction(account, payload);
    return await this.signAndSubmitTransaction(account, transaction);
  }

  // Prize Router Smart Contract Interactions
  async distributeRewards(account: Account, recipients: string[], amounts: number[]) {
    const payload: TransactionPayloadEntryFunction = {
      function: '0x1::tradeleague_prize_router::distribute_rewards',
      functionArguments: [recipients, amounts],
    };

    const transaction = await this.buildTransaction(account, payload);
    return await this.signAndSubmitTransaction(account, transaction);
  }

  // Utility Functions
  async waitForTransaction(transactionHash: string) {
    return await this.aptos.waitForTransaction({
      transactionHash,
    });
  }

  async getTransactionByHash(transactionHash: string) {
    return await this.aptos.getTransactionByHash({
      transactionHash,
    });
  }

  // Faucet for testnet (development only)
  async fundAccount(address: string) {
    try {
      return await this.aptos.fundAccount({
        accountAddress: address,
        amount: 100000000, // 1 APT in octas
      });
    } catch (error) {
      console.error('Error funding account:', error);
      throw error;
    }
  }

  // Account import/export
  static accountFromPrivateKey(privateKeyHex: string): Account {
    const privateKey = new Ed25519PrivateKey(privateKeyHex);
    return Account.fromPrivateKey({ privateKey });
  }

  static getPrivateKeyHex(account: Account): string {
    return account.privateKey.toString();
  }

  static getPublicKeyHex(account: Account): string {
    return account.publicKey.toString();
  }

  static getAddressHex(account: Account): string {
    return account.accountAddress.toString();
  }
}

// Singleton instance
export const aptosService = new AptosService();