import SwiftUI
import NetworkExtension

struct ContentView: View {
    @State private var isRunning = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(isRunning ? "VPN is running" : "VPN is stopped")
                .font(.headline)

            Button(action: {
                startMyVPN()
            }) {
                Text(isRunning ? "Stop VPN" : "Start VPN")
                    .font(.body)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 8).stroke())
            }
        }
        .padding()
    }
}


func startMyVPN() {
    // MARK: Configure Provider
            if NEFilterManager.shared().providerConfiguration == nil {
                let newConfiguration = NEFilterProviderConfiguration()
                newConfiguration.organization = "VPNDemo"
                newConfiguration.filterBrowsers = true
                newConfiguration.filterSockets = true
                NEFilterManager.shared().providerConfiguration = newConfiguration
            }
            NEFilterManager.shared().isEnabled = true
            NEFilterManager.shared().saveToPreferences { error in
                if let  saveError = error {
                    print("Failed to save the filter configuration: \(saveError)")
                }
            }
}


#Preview {
    ContentView()
}
