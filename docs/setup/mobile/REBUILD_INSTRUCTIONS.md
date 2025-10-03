# 🔨 Rebuild Instructions - Add Transaction Links to Activity

## Issue

Activity section shows transactions but **missing** the "transaction →" links below each item.

## Cause

New files not added to Xcode project yet. The app is running old code.

---

## Fix: Add Files to Xcode Project

### Step 1: Open Xcode

The workspace should already be open. If not:
```bash
open /Users/ellis.osborn/Aptos/TradeLeague/ios/TradeLeague.xcworkspace
```

### Step 2: Add New Files

You need to add **3 files** to the Xcode project:

#### Files to Add:
1. `ios/TradeLeague/Services/TransactionManager.swift`
2. `ios/TradeLeague/Views/AptosTestView.swift`
3. `ios/TradeLeague/Views/TransactionLinkView.swift`

#### How to Add:

**Option A: Drag and Drop (Easiest)**

1. Open Finder and navigate to:
   `/Users/ellis.osborn/Aptos/TradeLeague/ios/TradeLeague/`

2. In Xcode's left sidebar (Project Navigator):
   - Find the **Services** folder
   - Drag `TransactionManager.swift` into the Services folder

3. In Xcode's left sidebar:
   - Find the **Views** folder
   - Drag both `AptosTestView.swift` and `TransactionLinkView.swift` into Views folder

4. When the dialog appears:
   - ✅ Check "Copy items if needed" → **UNCHECK THIS** (files already in place)
   - ✅ Check "Create groups"
   - ✅ Check "Add to targets: TradeLeague"
   - Click **Add**

**Option B: Add Files Menu**

1. In Xcode, right-click on **Services** folder
2. Select **"Add Files to 'TradeLeague'"**
3. Navigate to: `/Users/ellis.osborn/Aptos/TradeLeague/ios/TradeLeague/Services/`
4. Select `TransactionManager.swift`
5. Make sure:
   - ❌ "Copy items if needed" is **UNCHECKED**
   - ✅ "Create groups" is checked
   - ✅ "Add to targets: TradeLeague" is checked
6. Click **Add**

7. Repeat for Views folder:
   - Right-click **Views** folder
   - **"Add Files to 'TradeLeague'"**
   - Navigate to: `/Users/ellis.osborn/Aptos/TradeLeague/ios/TradeLeague/Views/`
   - Select both `AptosTestView.swift` and `TransactionLinkView.swift`
   - Same settings as above
   - Click **Add**

### Step 3: Clean Build

In Xcode:
1. **Product** → **Clean Build Folder** (or Cmd+Shift+K)
2. Wait for it to complete

### Step 4: Build and Run

1. Select **iPhone 16** simulator (or any simulator)
2. Click ▶️ Play button (or Cmd+R)
3. Wait for build to complete
4. App will launch in simulator

---

## Verify It Works

### Check 1: Activity Section

1. Tap **"You"** tab (bottom right)
2. Tap **"Activity"** segment (top)
3. You should see transactions with:
   ```
   Followed Hyperion LP Strategy                    $1,000
   Follow • 28 sec                                ✓ Success

   transaction → 0x2d1bb9...c2eec4
   ↑ This should now appear!
   ```

### Check 2: Send Test Payment

1. Tap **"Aptos"** tab (dollar sign icon)
2. Enter amount (e.g., 0.01)
3. Tap "Send from A → B"
4. Transaction succeeds
5. Go to **"You"** → **"Activity"**
6. New transaction appears at top with clickable link

### Check 3: Click Transaction Link

1. In Activity, tap the "transaction" link
2. Safari/browser opens
3. Shows Aptos testnet explorer with transaction details

---

## If Files Are Already Added

If you see the files in Xcode's Project Navigator but still no links:

### Clean Build:
```
Cmd+Shift+K (Clean Build Folder)
Then Cmd+R (Build and Run)
```

### Or via Terminal:
```bash
cd /Users/ellis.osborn/Aptos/TradeLeague/ios
xcodebuild clean
```

Then build and run in Xcode.

---

## Expected Result

After rebuild, Activity section should show:

```
┌────────────────────────────────────────────────────┐
│ [+] Followed Hyperion LP Strategy           $1,000 │
│     Follow • 28 sec                       ✓ Success │
│                                                     │
│     transaction → 0x2d1bb9...c2eec4                │
│     ↑ Clickable, opens Aptos explorer              │
└────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────┐
│ [⚡] Predicted APT price increase             $250 │
│     Prediction • 2 hr, 0 min              ✓ Success │
│                                                     │
│     transaction → 0x3a2cc8...9f3ec5                │
│     ↑ Clickable, opens Aptos explorer              │
└────────────────────────────────────────────────────┘
```

---

## Troubleshooting

### "Cannot find TransactionManager"
- File not added to Xcode project
- Follow Step 2 above

### "Cannot find AptosTestView"
- File not added to Xcode project
- Follow Step 2 above

### Still no transaction links
- Clean build: Cmd+Shift+K
- Rebuild: Cmd+R
- Check that files are in correct folders in Xcode

### Build errors
1. Clean build folder
2. Close Xcode
3. Delete derived data:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
4. Reopen Xcode
5. Build again

---

## Quick Command Reference

### Open Xcode:
```bash
open /Users/ellis.osborn/Aptos/TradeLeague/ios/TradeLeague.xcworkspace
```

### Clean build via terminal:
```bash
cd /Users/ellis.osborn/Aptos/TradeLeague/ios
xcodebuild clean
```

### Build via terminal:
```bash
cd /Users/ellis.osborn/Aptos/TradeLeague/ios
xcodebuild -workspace TradeLeague.xcworkspace -scheme TradeLeague -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 16'
```

---

## Summary Checklist

- [ ] Add `TransactionManager.swift` to Services folder in Xcode
- [ ] Add `AptosTestView.swift` to Views folder in Xcode
- [ ] Add `TransactionLinkView.swift` to Views folder in Xcode
- [ ] Clean build (Cmd+Shift+K)
- [ ] Build and run (Cmd+R)
- [ ] Check Activity section shows transaction links
- [ ] Test clicking a transaction link
- [ ] Verify it opens Aptos testnet explorer

---

Once the files are added and rebuilt, every transaction in Activity will show the clickable "transaction →" link! 🚀
