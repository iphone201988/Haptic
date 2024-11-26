import UIKit

// MARK: - SceneDelegate Class
// The SceneDelegate is responsible for managing the lifecycle of your app's scenes,
// including when the app enters the foreground, background, or becomes active.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?  // The main window of the app.

    // MARK: - Scene Lifecycle Methods

    /**
     Called when a new scene session is being connected to the app.
     - Parameter scene: The scene object being connected.
     - Parameter session: The session object representing the session that is being connected.
     - Parameter connectionOptions: Options that describe how the scene is being connected.
     */
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure the scene is of type UIWindowScene and initialize the window.
        guard let _ = (scene as? UIWindowScene) else { return }
        AppRouter.shared.setRootViewController(to: .hapticVC, in: .main)
    }

    /**
     Called when the scene is disconnected (when it's no longer visible or active).
     - Parameter scene: The scene object that is being disconnected.
     */
    func sceneDidDisconnect(_ scene: UIScene) { }

    /**
     Called when the scene has become active.
     - Parameter scene: The scene object that has become active.
     */
    func sceneDidBecomeActive(_ scene: UIScene) { }

    /**
     Called when the scene will resign active status (e.g., when the app goes into the background).
     - Parameter scene: The scene object that will resign active.
     */
    func sceneWillResignActive(_ scene: UIScene) { }

    /**
     Called when the scene is about to enter the foreground (become active).
     - Parameter scene: The scene object that is about to enter the foreground.
     */
    func sceneWillEnterForeground(_ scene: UIScene) { }

    /**
     Called when the scene has entered the background.
     - Parameter scene: The scene object that has entered the background.
     */
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
