import UIKit

class HapticVC: UIViewController {
    
    // ViewModel that manages the haptic feedback logic
    private var viewModel: HapticViewModel!
    
    // A lazy-loaded UIView that will represent the point being updated based on touch events
    private lazy var pointView: UIView = {
        let pointView = UIView()
        return pointView
    }()
    
    @IBOutlet weak var hapticView: TouchHapticView!
    
    // Lifecycle method that gets called when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // Initial setup method where we configure the view and ViewModel
    private func initialSetup() {
        // Set the side length of the point view (circle) and get a random starting point in the safe area
        let pointSide: CGFloat = 30
        let randomPoint = HelperUtil.getRandomPointInSafeArea()
        
        // Set up the point view with the calculated size
        handlePointViewSetup(with: pointSide)
        
        // Initialize the viewModel with the point's side length (halved for its radius), the delegate, and the initial state
        viewModel = HapticViewModel(pointSide: pointSide / 2,
                                    delegate: self,
                                    state: .initial(randomPoint))
        
        // Set the current ViewController as the delegate of the TouchHapticView to receive touch events
        hapticView.delegate = self
    }
    
    // Method to configure the point view's appearance (position, color, and size)
    private func handlePointViewSetup(with pointSide: CGFloat) {
        // Make the point view's background clear and set its corner radius for circular shape
        pointView.backgroundColor = .clear
        pointView.layer.cornerRadius = pointSide / 2
        
        // Set the initial frame for the point view with an off-screen starting position
        pointView.frame = .init(origin: .init(x: -50, y: -50),
                                size: .init(width: pointSide, height: pointSide))
        
        // Add the point view to the main view
        view.addSubview(pointView)
    }
}

// MARK: - TouchEventDelegate

// Extension conforming to the TouchEventDelegate to handle touch events
extension HapticVC: TouchEventDelegate {
    
    // Called when the touch location is updated (i.e., when the user moves their finger)
    func didUpdateTouchLocation(_ touchLocation: CGPoint) {
        // Pass the touch location to the ViewModel for distance updates
        viewModel.updateDistance(touchLocation: touchLocation)
    }
    
    // Called when the touch ends (user lifts their finger)
    func didEndTouch() {
        // Stop continuous haptic feedback when the touch ends
        viewModel.stopContinuousHaptic()
    }
}

// MARK: - HapticStateProtocol

// Extension conforming to the HapticStateProtocol to update the UI based on the current state
extension HapticVC: HapticStateProtocol {
    
    // Updates the color of the point view based on the intensity of the haptic feedback
    func updatePointColor(intensity: Float) {
        // Use a helper method to get a color based on the intensity and update the point view's background color
        pointView.backgroundColor = HelperUtil.getColor(forProgress: intensity)
    }
    
    // Updates the position of the point view based on the calculated point
    func updatePointCenter(point: CGPoint) {
        // Update the point view's center to the new position
        pointView.center = point
    }
    
    // Initial setup of the point's position when first loading the screen or when reset
    func pointInitialSetup(point: CGPoint) {
        // Set the point view's initial position
        pointView.center = point
    }
}
