import UIKit

// ViewModel that handles the business logic for haptic feedback and point movement
class HapticViewModel {
    
    // Enum to track the state of the point (initial, idle, finding, or reached)
    enum PointState {
        case initial(CGPoint)  // Initial state with the point's initial position
        case idle              // Idle state (no interaction)
        case finding(CGPoint)  // Finding state when the touch is moving towards the point
        case reached(CGPoint)  // Reached state when the point is found
    }
    
    // Private properties
    private var hapticManager: HapticManager      // Manages the haptic feedback
    private(set) var distance: CGFloat = 0.0      // Stores the distance between touch and the point
    private var state: PointState {               // The current state of the point
        didSet {
            handlePointState(state: state)        // Handle the state change
        }
    }
    
    // Delegate to update the UI based on the state changes
    public weak var delegate: HapticStateProtocol?
    
    // Haptic intensity based on the distance to the point
    private(set) var intensity: Float = 0.0
    
    // Position and radius of the point
    private var pointPosition: CGPoint = .zero
    private var pointRadius: CGFloat
    
    // Initializer to set up the ViewModel with the required parameters
    init(pointSide: CGFloat = 30.0,
         delegate: HapticStateProtocol,
         state: PointState) {
        self.hapticManager = HapticManager()     // Initialize the haptic manager
        self.pointRadius = pointSide / 2         // Set the radius of the point
        self.delegate = delegate                 // Assign the delegate
        self.state = state                       // Set the initial state
        
        handlePointState(state: state)           // Handle the state when the ViewModel is initialized
    }
    
    // Method to update the distance from the touch location to the point
    public func updateDistance(touchLocation: CGPoint) {
        state = .finding(touchLocation)           // Change state to "finding" when the touch moves
    }
    
    // Stop the continuous haptic feedback and set the state to idle
    public func stopContinuousHaptic() {
        state = .idle                             // Change state to "idle"
    }
    
    // Handles state changes and delegates actions based on the current state
    private func handlePointState(state: PointState) {
        switch state {
        case .idle:
            handleIdleState()                   // Handle when the state is idle
            
        case .finding(let location):
            handleFindingState(touchLocation: location) // Handle when the state is "finding"
            
        case .reached(let newPoint):
            handlePointReached(newPoint: newPoint) // Handle when the state is "reached"
            
        case .initial(let initialPoint):
            handleInitialState(initialPoint: initialPoint) // Handle the initial state
        }
    }
    
    // Handle the "finding" state where the touch is moving towards the point
    private func handleFindingState(touchLocation: CGPoint) {
        distance = HelperUtil.calculateDistance(from: touchLocation, to: pointPosition)  // Calculate the distance
        
        updateHapticFeedback()  // Update haptic feedback based on distance
    }
    
    // Update haptic feedback intensity based on the distance to the point
    private func updateHapticFeedback() {
        intensity = HelperUtil.calculateIntensity(for: distance)  // Calculate intensity
        hapticManager.updateContinuousHaptic(intensity: intensity)  // Update the haptic feedback
        delegate?.updatePointColor(intensity: intensity)  // Update point color based on intensity
        
        // If the distance is less than or equal to the point's radius, the point is "reached"
        if distance <= (pointRadius * 2) {
            let newPoint = HelperUtil.getRandomPointInSafeArea()  // Generate a new random point
            state = .reached(newPoint)  // Change state to "reached"
        }
    }
    
    // Handle the "reached" state when the point is found
    private func handlePointReached(newPoint: CGPoint) {
        pointPosition = newPoint  // Update the point's position
        delegate?.updatePointCenter(point: newPoint)  // Update the point's center in the UI
        hapticManager.triggerContactHaptic()  // Trigger a contact haptic feedback
    }
    
    // Handle the "idle" state where no touch interactions are happening
    private func handleIdleState() {
        hapticManager.stopContinuousHaptic()  // Stop continuous haptic feedback
    }
    
    // Handle the "initial" state where the point is first set up
    private func handleInitialState(initialPoint: CGPoint) {
        pointPosition = initialPoint  // Set the initial point's position
        delegate?.pointInitialSetup(point: initialPoint)  // Perform initial setup in the UI
        delegate?.updatePointColor(intensity: 0)  // Set the initial color (no intensity)
    }
}
