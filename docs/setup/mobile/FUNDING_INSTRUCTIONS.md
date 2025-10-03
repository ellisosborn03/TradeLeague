# 🚀 Fund Your Aptos Testnet Wallets

## Quick Start - Fund Both Wallets Now

Both wallets need testnet APT tokens to function. Follow these steps:

### 1. Fund Wallet A (Sender)
**Click here:** https://aptos.dev/network/faucet?address=0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155

1. Sign in with your Google account
2. The address should be pre-filled
3. Click **"Request APT"**
4. Wait 5-10 seconds

### 2. Fund Wallet B (Receiver)
**Click here:** https://aptos.dev/network/faucet?address=0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a

1. Sign in with your Google account (same one)
2. The address should be pre-filled
3. Click **"Request APT"**
4. Wait 5-10 seconds

---

## Verify Funding

### Option 1: Check via Explorer (Visual)

**Wallet A:** https://explorer.aptoslabs.com/account/0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155?network=testnet

**Wallet B:** https://explorer.aptoslabs.com/account/0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a?network=testnet

Look for the APT balance on each page. Should show something like "100,000,000 Octas" (= 1 APT).

### Option 2: Check via Script

```bash
cd /Users/ellis.osborn/Aptos/TradeLeague
./check-wallets.sh
```

---

## Test Transaction

Once both wallets are funded, test the transaction flow:

```bash
# Send 0.01 APT (1,000,000 octas) from Wallet A to Wallet B
aptos account transfer \
  --profile wallet-a \
  --account 0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a \
  --amount 1000000
```

The output will include a transaction hash. View it on the explorer:
```
https://explorer.aptoslabs.com/txn/[TRANSACTION_HASH]?network=testnet
```

---

## Wallet Summary

| Wallet | Purpose | Address |
|--------|---------|---------|
| **Wallet A** | Sender (sends all payments) | `0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155` |
| **Wallet B** | Receiver (receives all payments) | `0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a` |

---

## Troubleshooting

### "Account not found" error
- The account exists on-chain but hasn't been funded yet
- Visit the faucet links above to fund the accounts

### Faucet says "Rate limited"
- You can only request tokens once every few minutes
- Wait 5 minutes and try again
- Or use a different Google account

### Transaction fails
- Make sure Wallet A has sufficient balance
- Minimum balance needed: amount to send + gas fee (usually ~0.0001 APT)

---

## Need More APT?

You can request more testnet APT at any time by visiting the faucet links. The faucet typically gives 1 APT (100,000,000 octas) per request.

**Wallet A Faucet:** https://aptos.dev/network/faucet?address=0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155

**Wallet B Faucet:** https://aptos.dev/network/faucet?address=0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a

---

✅ **Once funded, you're ready to integrate the wallets into the TradeLeague app!**

See `APTOS_WALLETS.md` for full technical details and integration code.
