#!/bin/bash

# TradeLeague - Aptos Wallet Checker
# This script checks the balance and status of both testnet wallets

echo "=============================================="
echo "TradeLeague - Aptos Testnet Wallet Status"
echo "=============================================="
echo ""

# Wallet A
echo "📍 WALLET A (Sender)"
echo "Address: 0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155"
echo "Explorer: https://explorer.aptoslabs.com/account/0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155?network=testnet"
echo ""
echo "Checking balance..."
aptos account list --profile wallet-a 2>/dev/null || echo "⚠️  Wallet A is not funded. Fund it here: https://aptos.dev/network/faucet?address=0x1c2cf8c859fc98c4bc8ebaeec177489b191574000bd961db1b51670fb5e7b155"
echo ""
echo "----------------------------------------------"
echo ""

# Wallet B
echo "📍 WALLET B (Receiver)"
echo "Address: 0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a"
echo "Explorer: https://explorer.aptoslabs.com/account/0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a?network=testnet"
echo ""
echo "Checking balance..."
aptos account list --profile wallet-b 2>/dev/null || echo "⚠️  Wallet B is not funded. Fund it here: https://aptos.dev/network/faucet?address=0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a"
echo ""
echo "----------------------------------------------"
echo ""

echo "💡 To fund wallets:"
echo "1. Visit the faucet links above"
echo "2. Sign in with Google"
echo "3. Click 'Request APT'"
echo ""
echo "💡 To send a test transaction:"
echo "aptos account transfer --profile wallet-a --account 0xadd13b17d2ed6eba21fd5a44849c88734ccf644b3f5b1415978d16b99294de2a --amount 1000000"
echo ""
echo "=============================================="
