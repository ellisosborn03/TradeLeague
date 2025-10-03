# Aptos Testnet Wallets - TradeLeague

This document contains the full configuration and access credentials for the two Aptos testnet wallets used in the TradeLeague application.

## Wallet A (Sender Wallet)

**Purpose:** This wallet is used to send all user-initiated transactions in the app.

**Address:** `0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155`

**Public Key:** `A281F1D6C7CEE76AED519C524428DF84E05A866EBA8858B2EA3749D4CEEC577B`

**Private Key:** `B37A61F467D0D226B671BFC8A842FB3036F7BE8B55BEAA66C168154053B40A0D`

**Profile Name:** `wallet-a`

**Testnet Explorer:** https://explorer.aptoslabs.com/account/0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155?network=testnet

**Faucet Link:** https://aptos.dev/network/faucet?address=0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155

---

## Wallet B (Receiver Wallet)

**Purpose:** This wallet receives all payments from Wallet A.

**Address:** `0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a`

**Public Key:** `ADD13B17D2ED6EBA21FD5A44849C88734CCF644B3F5B1415978D16B99294DE2A`

**Private Key:** `3114BB80295C5CE57EBD719ED974820B1FDDFF5E0EAE68B2101CA88A10E787D5`

**Profile Name:** `wallet-b`

**Testnet Explorer:** https://explorer.aptoslabs.com/account/0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a?network=testnet

**Faucet Link:** https://aptos.dev/network/faucet?address=0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a

---

## Transaction Flow

**All user actions in the app follow this pattern:**

1. User initiates a payment action (trade, prediction, etc.)
2. User enters an amount in the app
3. App sends that exact amount from **Wallet A → Wallet B** on Aptos testnet
4. App displays transaction link in the format: `transaction → https://explorer.aptoslabs.com/txn/[TRANSACTION_HASH]?network=testnet`

---

## Funding Instructions

⚠️ **IMPORTANT:** These wallets need to be funded before use.

### Option 1: Web Faucet (Recommended)

1. Visit the faucet links above for each wallet
2. Sign in with your Google account
3. Click "Request APT" to fund each wallet
4. Wait a few seconds for tokens to appear

### Option 2: CLI Commands

```bash
# Check wallet balances
aptos account list --profile wallet-a
aptos account list --profile wallet-b

# Note: Programmatic faucet funding requires Google authentication for testnet
# Use the web faucet links above instead
```

---

## Using the Wallets in the App

### Environment Variables

Add these to your app's environment configuration:

```env
APTOS_NETWORK=testnet
APTOS_WALLET_A_ADDRESS=0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155
APTOS_WALLET_A_PRIVATE_KEY=B37A61F467D0D226B671BFC8A842FB3036F7BE8B55BEAA66C168154053B40A0D
APTOS_WALLET_B_ADDRESS=0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a
APTOS_WALLET_B_PRIVATE_KEY=3114BB80295C5CE57EBD719ED974820B1FDDFF5E0EAE68B2101CA88A10E787D5
APTOS_NODE_URL=https://fullnode.testnet.aptoslabs.com/v1
APTOS_FAUCET_URL=https://faucet.testnet.aptoslabs.com
APTOS_EXPLORER_BASE=https://explorer.aptoslabs.com
```

### Importing Wallets Programmatically

```typescript
import { AptosClient, AptosAccount, FaucetClient, HexString } from "aptos";

const NODE_URL = "https://fullnode.testnet.aptoslabs.com/v1";
const FAUCET_URL = "https://faucet.testnet.aptoslabs.com";

// Initialize Aptos client
const client = new AptosClient(NODE_URL);
const faucetClient = new FaucetClient(NODE_URL, FAUCET_URL);

// Import Wallet A
const walletAPrivateKey = new HexString("B37A61F467D0D226B671BFC8A842FB3036F7BE8B55BEAA66C168154053B40A0D");
const walletA = new AptosAccount(walletAPrivateKey.toUint8Array());

// Import Wallet B
const walletBPrivateKey = new HexString("3114BB80295C5CE57EBD719ED974820B1FDDFF5E0EAE68B2101CA88A10E787D5");
const walletB = new AptosAccount(walletBPrivateKey.toUint8Array());

// Example: Send transaction from Wallet A to Wallet B
async function sendPayment(amountInOctas: number) {
  const txnHash = await client.generateSignSubmitWaitForTransaction(
    walletA,
    {
      function: "0x1::coin::transfer",
      type_arguments: ["0x1::aptos_coin::AptosCoin"],
      arguments: [walletB.address().hex(), amountInOctas],
    }
  );

  return {
    hash: txnHash,
    explorerUrl: `https://explorer.aptoslabs.com/txn/${txnHash}?network=testnet`
  };
}
```

---

## Security Notes

⚠️ **WARNING:** These private keys provide FULL CONTROL over the wallets.

- These are TESTNET wallets only - no real value
- Never use these keys for mainnet
- Never commit private keys to public repositories
- Store keys securely in environment variables or secure key management systems
- For production, implement proper key management and security practices

---

## Verification Commands

```bash
# Check if wallets are funded
aptos account list --profile wallet-a
aptos account list --profile wallet-b

# View account resources
aptos account resource --profile wallet-a --resource-type 0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>
aptos account resource --profile wallet-b --resource-type 0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>

# Send a test transaction from Wallet A to Wallet B
aptos account transfer --profile wallet-a --account 0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a --amount 1000000

# View transaction history
# Visit the explorer links above
```

---

## Files Location

All wallet keys are stored in: `/Users/ellis.osborn/Aptos/TradeLeague/.aptos-wallets/`

```
.aptos-wallets/
├── wallet-a          # Wallet A private key
├── wallet-a.pub      # Wallet A public key
├── wallet-b          # Wallet B private key
└── wallet-b.pub      # Wallet B public key
```

---

## Next Steps

1. ✅ Fund both wallets using the web faucet links above
2. ✅ Verify funding by checking the explorer links
3. ✅ Integrate wallets into the TradeLeague app
4. ✅ Implement transaction flow (Wallet A → Wallet B)
5. ✅ Display transaction explorer links in the UI

---

**Last Updated:** 2025-10-01
