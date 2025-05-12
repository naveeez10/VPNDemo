import NetworkExtension

class FilterControlProvider: NEFilterControlProvider {

    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        // Add code to initialize the filter
        completionHandler(nil)
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code to clean up filter resources
        completionHandler()
    }
    
    override func handleNewFlow(_ flow: NEFilterFlow, completionHandler: @escaping (NEFilterControlVerdict) -> Void) {
        // Add code to determine if the flow should be dropped or not, downloading new rules if required
        if let host = flow.url?.host?.lowercased() {
            for domain in ["youtube.com"] {
                if host.hasSuffix(domain) {
                    completionHandler(.drop(withUpdateRules: false))
                    return
                }
            }
        }
        completionHandler(.allow(withUpdateRules: false))
    }
}
