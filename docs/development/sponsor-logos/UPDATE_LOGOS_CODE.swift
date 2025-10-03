// Updated SponsorLogoView to use local assets
struct SponsorLogoView: View {
    let sponsorName: String
    let size: CGSize
    
    var body: some View {
        Group {
            // Try to load local image first, fallback to branded icon
            if let logoName = localImageName {
                Image(logoName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size.width, height: size.height)
            } else {
                // Fallback to branded circular icon
                ZStack {
                    Circle()
                        .fill(logoBackgroundColor)
                        .frame(width: size.width, height: size.height)
                    
                    Image(systemName: logoIcon)
                        .font(.system(size: size.width * 0.5, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private var localImageName: String? {
        switch sponsorName.lowercased() {
        case "circle":
            return "circle-logo"
        case "hyperion":
            return "hyperion-logo"
        case "merkle", "merkle trade":
            return "merkle-logo"
        case "tapp", "tapp exchange", "tapp network":
            return "tapp-logo"
        case "panora":
            return "panora-logo"
        case "kana", "kana labs":
            return "kana-logo"
        case "nodit":
            return "nodit-logo"
        case "ekiden":
            return "ekiden-logo"
        default:
            return nil
        }
    }
    
    // Keep the existing branded fallback system
    private var logoBackgroundColor: Color { /* existing code */ }
    private var logoIcon: String { /* existing code */ }
}

