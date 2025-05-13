import NetworkExtension
import UserNotifications

class FilterControlProvider: NEFilterControlProvider {

    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        // Request notification permission once when the filter starts
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                NSLog("Notification auth error: \(error)")
            }
            completionHandler(nil)
        }
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    override func handleNewFlow(_ flow: NEFilterFlow, completionHandler: @escaping (NEFilterControlVerdict) -> Void) {
        // If there's a URL, show it in a debug notification
        if let urlString = flow.url?.absoluteString {
            let content = UNMutableNotificationContent()
            content.title = "Network Flow"
            content.body = urlString
            content.sound = .default
            
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: nil
            )
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    NSLog("Failed to schedule notification: \(error)")
                }
            }
        }
        
        // Your existing block logic
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
