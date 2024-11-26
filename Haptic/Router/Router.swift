import UIKit

final class AppRouter {

    // MARK: - Singleton Instance
    static let shared = AppRouter()

    // Private initializer to enforce singleton usage
    private init() {}

    // MARK: - Navigation Methods

    /// Sets the root view controller of the application's main window
    /// - Parameters:
    ///   - destination: The destination screen to set as root
    ///   - storyboard: The storyboard containing the destination view controller
    public func setRootViewController(to destination: Destination, in storyboard: Storyboard) {
        guard let destinationVC = instantiateViewController(for: destination, in: storyboard) else {
            print("Error: Could not instantiate view controller for \(destination.rawValue) in storyboard \(storyboard.rawValue)")
            return
        }
        
        guard let window = getKeyWindow() else {
            print("Error: Could not find the key window.")
            return
        }

        let navigationController = UINavigationController(rootViewController: destinationVC)
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    // MARK: - Private Methods

    /// Instantiates a view controller from a given storyboard and destination
    /// - Parameters:
    ///   - destination: The destination view controller to instantiate
    ///   - storyboard: The storyboard containing the view controller
    /// - Returns: The instantiated view controller, or nil if it cannot be instantiated
    private func instantiateViewController(for destination: Destination, in storyboard: Storyboard) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: destination.rawValue)
    }
    
    /// Retrieves the key window for the application
    /// - Returns: The key `UIWindow` if available
    public func getKeyWindow() -> UIWindow? {
        let sceneDelegate = UIApplication.shared.connectedScenes
            .first?.delegate as? SceneDelegate
        return sceneDelegate?.window
    }
}

// MARK: - Supporting Enums

extension AppRouter {

    /// Enum representing available storyboards
    enum Storyboard: String {
        case main = "Main"
        // Add more storyboard names as needed
    }

    /// Enum representing destination view controllers
    enum Destination: String {
        case hapticVC = "HapticVC"
        // Add more destinations as needed
    }

    /// Enum representing types of navigation transitions
    enum TransitionType {
        case push
        case presentModally
    }
}
