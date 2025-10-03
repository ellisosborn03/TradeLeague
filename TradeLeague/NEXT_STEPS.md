# 🚀 Next Steps - Complete Aptos Integration

## Current Status

✅ Wallets created (Wallet A & B)
✅ Code integrated (AptosService, UI components)
⚠️ Wallets need funding
⚠️ New files need to be added to Xcode project

---

## Step 1: Fund Both Wallets (REQUIRED)

Visit these faucet links and request APT for both wallets:

**Wallet A:**
https://aptos.dev/network/faucet?address=0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155

**Wallet B:**
https://aptos.dev/network/faucet?address=0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a

Instructions:
1. Click each link
2. Sign in with Google
3. Click "Request APT"
4. Wait 5-10 seconds

---

## Step 2: Add New Files to Xcode Project

The Xcode workspace is now open. You need to add the two new files:

### Files to Add:
1. `ios/TradeLeague/Views/AptosTestView.swift`
2. `ios/TradeLeague/Views/TransactionLinkView.swift`

### How to Add Them in Xcode:

1. In Xcode's left sidebar (Project Navigator), find the **TradeLeague** → **Views** folder

2. Right-click on the **Views** folder → **Add Files to "TradeLeague"**

3. Navigate to: `/Users/ellis.osborn/Aptos/TradeLeague/ios/TradeLeague/Views/`

4. Select these files:
   - `AptosTestView.swift`
   - `TransactionLinkView.swift`

5. Make sure these checkboxes are selected:
   - ✅ "Copy items if needed" (UNCHECK this - files are already in place)
   - ✅ "Create groups"
   - ✅ "Add to targets: TradeLeague"

6. Click **"Add"**

---

## Step 3: Build and Run

Once the files are added:

1. Select iPhone 16 simulator (or any simulator)
2. Click the ▶️ Play button or press Cmd+R
3. App will build and launch

---

## Step 4: Test Aptos Integration

Once the app is running:

1. Tap the **"Aptos"** tab at the bottom (dollar sign icon)

2. You should see:
   - Wallet A balance
   - Wallet B balance
   - Send payment interface

3. Test sending a payment:
   - Enter amount (e.g., 0.01)
   - Tap "Send from A → B"
   - Wait for confirmation
   - Click the transaction link to view on Aptos Explorer

---

## Alternative: Add Files via Command Line

If you prefer, you can add the files manually to the Xcode project file:

```bash
# Open the project in Xcode - it should auto-detect the new files
# Or manually edit the project.pbxproj file (advanced)
```

---

## Verify Everything is Working

### 1. Check Wallet Balances

```bash
./check-wallets.sh
```

You should see non-zero balances if wallets are funded.

### 2. Send Test Transaction via CLI

```bash
aptos account transfer \
  --profile wallet-a \
  --account 0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a \
  --amount 1000000
```

This sends 0.01 APT from Wallet A to Wallet B.

### 3. View on Explorer

Visit:
- Wallet A: https://explorer.aptoslabs.com/account/0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155?network=testnet
- Wallet B: https://explorer.aptoslabs.com/account/0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a?network=testnet

---

## What the Aptos Tab Does

The new "Aptos" tab in the app provides:

✅ **Live Wallet Balances** - Shows real APT balances from testnet
✅ **Send Test Payments** - Send APT from Wallet A → Wallet B
✅ **Transaction Links** - Every payment shows an explorer link
✅ **Demo/Testing Interface** - Test the payment flow before integrating into other features

---

## Integration into Other Features

Once you've tested the Aptos tab, you can integrate payments into:

### Predictions (PredictView)
```swift
// When user places a bet
let (hash, url) = try await AptosService.shared.sendPayment(amountInAPT: betAmount)

// Show transaction link
TransactionLinkView(transactionHash: hash, explorerURL: url)
```

### Vault Following (TradeView)
```swift
// When user follows a vault
let (hash, url) = try await AptosService.shared.sendPayment(amountInAPT: followAmount)

// Show success with transaction
TransactionSuccessView(
    message: "Successfully followed vault!",
    transactionHash: hash,
    explorerURL: url,
    onDismiss: { /* ... */ }
)
```

### League Entry (LeagueView)
```swift
// When user joins a league
let (hash, url) = try await AptosService.shared.sendPayment(amountInAPT: entryFee)

// Display transaction link
```

See `INTEGRATION_GUIDE.md` for detailed examples.

---

## Troubleshooting

### "Cannot find AptosTestView in scope"
- Files not added to Xcode project
- Follow Step 2 above to add the files

### "Wallet balance is 0"
- Wallets not funded yet
- Visit the faucet links in Step 1

### Build errors
- Clean build folder: Cmd+Shift+K in Xcode
- Or: `cd ios && xcodebuild clean`

### Transaction fails
- Check Wallet A has sufficient balance
- Verify wallets are funded via explorer links

---

## Files Created

### Documentation
- `APTOS_SETUP_COMPLETE.md` - Overview and quick reference
- `APTOS_WALLETS.md` - Complete wallet details & credentials
- `FUNDING_INSTRUCTIONS.md` - Step-by-step funding guide
- `INTEGRATION_GUIDE.md` - Code examples & usage
- `NEXT_STEPS.md` - This file

### Code
- `ios/TradeLeague/Services/AptosService.swift` - ✅ Added to project (updated)
- `ios/TradeLeague/Views/TransactionLinkView.swift` - ⚠️ Need to add to Xcode
- `ios/TradeLeague/Views/AptosTestView.swift` - ⚠️ Need to add to Xcode
- `ios/TradeLeague/ContentView.swift` - ✅ Added to project (updated)

### Scripts & Config
- `check-wallets.sh` - Check wallet balances
- `.aptos-wallets/` - Wallet key files

---

## Summary Checklist

- [ ] Fund Wallet A (visit faucet link)
- [ ] Fund Wallet B (visit faucet link)
- [ ] Add `AptosTestView.swift` to Xcode project
- [ ] Add `TransactionLinkView.swift` to Xcode project
- [ ] Build and run the app (Cmd+R)
- [ ] Test payment in Aptos tab
- [ ] View transaction on explorer

---

**Once complete, you'll have:**
- ✅ Live Aptos testnet integration
- ✅ Working payment system (Wallet A → Wallet B)
- ✅ Transaction links in UI
- ✅ Demo interface for testing
- ✅ Ready to integrate into all app features

For questions, refer to the documentation files or check the integration guide!
