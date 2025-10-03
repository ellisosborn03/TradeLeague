#!/bin/bash

echo "🎨 Adding Sponsor Logos to TradeLeague App..."

cd /Users/ellis.osborn/Aptos/TradeLeague-SwiftUI/Assets.xcassets

echo "📁 Created image sets:"
echo "  - hyperion-logo.imageset"
echo "  - merkle-logo.imageset" 
echo "  - tapp-logo.imageset"
echo "  - panora-logo.imageset"

echo ""
echo "📋 MANUAL STEP REQUIRED:"
echo "You need to copy the uploaded images to these locations:"
echo ""
echo "1. Save the Hyperion logo (H gradient) as:"
echo "   → hyperion-logo.imageset/hyperion-logo.png"
echo ""
echo "2. Save the Merkle Trade logo (green M) as:"
echo "   → merkle-logo.imageset/merkle-logo.png"
echo ""
echo "3. Save the Tapp Exchange logo (pink elephant) as:"
echo "   → tapp-logo.imageset/tapp-logo.png"
echo ""
echo "4. Save the Panora logo (teal P stripes) as:"
echo "   → panora-logo.imageset/panora-logo.png"
echo ""
echo "5. Then run: cd /Users/ellis.osborn/Aptos/TradeLeague-SwiftUI && xcodebuild -project TradeLeague.xcodeproj -scheme TradeLeague build"
echo "✨ The logos will then display properly in your app!"

