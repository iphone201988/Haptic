import UIKit

// Custom view that detects touch events and sends updates to its delegate
class TouchHapticView: UIView {

    // A weak reference to the delegate that conforms to TouchEventDelegate
    public weak var delegate: TouchEventDelegate?

    // This method is called when the user moves their finger across the screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Ensure there's at least one touch event
        guard let touch = touches.first else { return }

        // Get the location of the touch in the view's coordinate system
        let touchLocation = touch.location(in: self)

        // Inform the delegate about the updated touch location
        delegate?.didUpdateTouchLocation(touchLocation)
    }

    // This method is called when the user stops touching the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Inform the delegate that the touch has ended
        delegate?.didEndTouch()
    }
}
