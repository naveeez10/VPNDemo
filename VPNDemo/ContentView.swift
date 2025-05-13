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
    let manager = NEFilterManager.shared()

    // 1. Always load first
    manager.loadFromPreferences { loadError in
        guard loadError == nil else {
            print("Error loading filter prefs: \(loadError!)")
            return
        }

        // 2. Configure metadata
        manager.localizedDescription = "VPNDemo Content Filter"
        // This must match the bundle ID of your Network Extension target
        manager.providerConfiguration?.organization = ".com.naviz.VPNDemo.FilterDataProvider"

        // 3. Set up the provider configuration
        let filterConfig = NEFilterProviderConfiguration()
        filterConfig.organization   = "VPNDemo"
        filterConfig.filterBrowsers = true
        filterConfig.filterSockets  = true
        manager.providerConfiguration = filterConfig

        // 4. Enable and save
        manager.isEnabled = true
        manager.saveToPreferences { saveError in
            if let e = saveError {
                print("Failed to save the filter configuration: \(e)")
            } else {
                print("Filter configuration saved successfully.")
                // At this point, you must also start your FilterControlProvider/DataProvider
            }
        }
    }
}

#Preview {
    ContentView()
}
