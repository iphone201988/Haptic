import UIKit
import CoreHaptics

class HapticManager {
    private var hapticEngine: CHHapticEngine?  // CoreHaptics engine
    private var continuousPlayer: CHHapticAdvancedPatternPlayer?  // Player for continuous haptics
    private var pattern: CHHapticPattern?  // Predefined continuous haptic pattern
    
    init() {
        setupHaptics()
    }
    
    /// Initializes and starts the haptic engine.
    private func setupHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            showError("Haptic hardware is not supported.")
            return
        }
        
        do {
            hapticEngine = try CHHapticEngine()  // Initialize haptic engine
            try hapticEngine?.start()  // Start the engine
            pattern = try createContinuousHapticPattern()  // Pre-create a continuous haptic pattern
        } catch {
            showError("Haptic engine failed to start: \(error.localizedDescription)")
        }
    }
    
    /// Updates the intensity of continuous haptic feedback.
    func updateContinuousHaptic(intensity: Float) {
        do {
            if continuousPlayer == nil, let pattern = pattern {
                continuousPlayer = try hapticEngine?.makeAdvancedPlayer(with: pattern)  // Create player if needed
            }
            
            let intensityParameter = CHHapticDynamicParameter(
                parameterID: .hapticIntensityControl,
                value: intensity,
                relativeTime: 0
            )
            try continuousPlayer?.start(atTime: 0)  // Start playback
            try continuousPlayer?.sendParameters([intensityParameter], atTime: 0)  // Update intensity
        } catch {
            showError("Failed to update haptic intensity: \(error.localizedDescription)")
        }
    }
    
    /// Stops continuous haptic feedback.
    func stopContinuousHaptic() {
        do {
            try continuousPlayer?.stop(atTime: 0)  // Stop playback
            continuousPlayer = nil  // Reset the player
        } catch {
            showError("Failed to stop continuous haptic: \(error.localizedDescription)")
        }
    }
    
    /// Creates a continuous haptic pattern with default intensity and sharpness.
    private func createContinuousHapticPattern() throws -> CHHapticPattern {
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            ],
            relativeTime: 0,
            duration: 1.0
        )
        return try CHHapticPattern(events: [event], parameters: [])
    }
    
    /// Triggers a transient haptic event for feedback like "contact."
    func triggerContactHaptic() {
        do {
            let event = CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
                ],
                relativeTime: 0
            )
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)  // Create a transient player
            try player?.start(atTime: 0)  // Play the event
        } catch {
            showError("Failed to trigger contact haptic: \(error.localizedDescription)")
        }
    }
    
    /// Displays error messages using a custom alert manager.
    private func showError(_ message: String) {
        AlertViewManager.shared.showAlert(
            title: "Haptic Error",
            message: message
        )
    }
}
