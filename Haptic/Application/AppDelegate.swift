import UIKit

// MARK: - AppDelegate Class
// This is the main entry point for the application.
// The AppDelegate class manages the lifecycle of the app and handles important system events.
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    // Declare any global properties you need here (e.g., for haptic feedback or tracking app state).
    
    // MARK: - Application Lifecycle Methods

    /**
     Called when the app has finished launching.
     - Parameter application: The app instance.
     - Parameter launchOptions: Launch options, including any state information from the previous session.
     - Returns: A boolean indicating whether the launch process was successful.
     */
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Perform any setup after application launch.
        return true
    }

    // MARK: - UISceneSession Lifecycle
    /**
     Called when a new scene session is being created.
     - Parameter application: The app instance.
     - Parameter connectingSceneSession: The session being created.
     - Parameter options: Connection options for the session.
     - Returns: A UISceneConfiguration object to configure the scene.
     */
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
