import Foundation
import UIKit

class AlertViewManager {
    static let shared = AlertViewManager() // Singleton instance
    
    private init() {} // Private initializer to prevent external instantiation
    
    /// Displays an alert with the provided title, message, and action button title.
    /// - Parameters:
    ///   - title: The title text of the alert.
    ///   - message: The body text of the alert.
    ///   - actionTitle: Title for the alert's action button (default is "OK").
    func showAlert(title: String,
                   message: String,
                   actionTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert) // Create alert
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in }
        alert.addAction(action) // Add default action
        
        guard let topVC = topController() else { return } // Get top view controller
        topVC.present(alert, animated: true, completion: nil) // Present alert
    }
    
    /// Retrieves the top-most view controller in the current view hierarchy.
    private func topController() -> UIViewController? {
        if var topController = keyWindow()?.rootViewController { // Start with the root view controller
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController // Traverse presented view controllers
            }
            return topController
        }
        return nil
    }
    
    /// Retrieves the current key window.
    private func keyWindow() -> UIWindow? {
        for scene in UIApplication.shared.connectedScenes { // Iterate through connected scenes
            guard let windowScene = scene as? UIWindowScene else { continue }
            if windowScene.windows.isEmpty { continue }
            
            // Return the first key window in the scene
            guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { continue }
            return window
        }
        return nil
    }
}
