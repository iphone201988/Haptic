import Foundation

protocol TouchEventDelegate: AnyObject {
    /// Called when the touch location is updated.
    /// - Parameter touchLocation: The updated location of the touch point.
    func didUpdateTouchLocation(_ touchLocation: CGPoint)
    
    /// Called when the touch event ends.
    func didEndTouch()
}

// Protocol that defines methods for updating point position and color
protocol HapticStateProtocol: AnyObject {
    func updatePointCenter(point: CGPoint)      // Updates the point's position
    func pointInitialSetup(point: CGPoint)      // Initial setup for the point
    func updatePointColor(intensity: Float)     // Updates the point's color based on haptic intensity
}
