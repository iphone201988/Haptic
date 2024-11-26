import UIKit

class HelperUtil {
    
    static var diagonalDistance: CGFloat?  // Cached value for the screen's diagonal distance
    
    /// Returns the diagonal distance of the screen in points.
    static func getScreenDiagonalDistance() -> CGFloat {
        // Return the cached diagonal distance if available
        if let diagonalDistance = diagonalDistance {
            return diagonalDistance
        }
        
        let screenSize = getScreenSize()  // Get the screen's size
        let width = screenSize.width
        let height = screenSize.height
        let diagonalDistance = sqrt(pow(width, 2) + pow(height, 2))  // Calculate the diagonal using Pythagoras theorem
        self.diagonalDistance = diagonalDistance  // Cache the result
        return diagonalDistance
    }
    
    /// Returns the center point of the screen.
    static func getScreenCenter() -> CGPoint {
        let screenSize = getScreenSize()  // Get the screen's size
        return CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)  // Calculate and return the center
    }
    
    /// Returns the screen size in points.
    static func getScreenSize() -> CGSize {
        return UIScreen.main.bounds.size  // Use the main screen's bounds to get the size
    }
    
    /// Calculates the distance between two points.
    static func calculateDistance(from point1: CGPoint, to point2: CGPoint) -> CGFloat {
        return hypot(point2.x - point1.x, point2.y - point1.y)  // Use the hypot function to calculate Euclidean distance
    }
    
    /// Calculates the intensity for haptic feedback based on the distance.
    static func calculateIntensity(for distance: CGFloat) -> Float {
        let maxDistance: CGFloat = getScreenDiagonalDistance()  // Get the screen's diagonal distance (max distance)
        let normalizedDistance = min(maxDistance - distance, maxDistance) / maxDistance  // Normalize the distance
        return max(Float(normalizedDistance), 0.2)  // Return the intensity value, ensuring a minimum of 0.2
    }
    
    /// Returns a random point within the safe area of the screen, with padding.
    static func getRandomPointInSafeArea(padding: CGFloat = 30) -> CGPoint {
        guard let window = AppRouter.shared.getKeyWindow() else {
            return CGPoint.zero  // Return (0, 0) if window is unavailable
        }
        
        let safeAreaInsets = window.safeAreaInsets  // Get the safe area insets of the window
        let screenSize = getScreenSize()  // Get the screen's size
        
        // Adjust ranges for safe area with padding
        let minX = safeAreaInsets.left + padding
        let maxX = screenSize.width - safeAreaInsets.right - padding
        let minY = safeAreaInsets.top + padding
        let maxY = screenSize.height - safeAreaInsets.bottom - padding
        
        // Ensure valid ranges to prevent negative or inverted ranges
        guard minX < maxX && minY < maxY else {
            return CGPoint.zero  // Return (0, 0) if padding exceeds available space
        }
        
        // Generate a random x and y within the adjusted safe area
        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)
        
        return CGPoint(x: randomX, y: randomY)  // Return the random point
    }
    
    /// Interpolates between red and green based on the progress value, returning a color.
    static func getColor(forProgress progress: Float) -> UIColor {
        // Clamp the progress value between 0 and 1
        let clampedProgress = max(0, min(progress, 1))
        
        // Define the start (red) and end (green) colors for the progress
        let startColor = UIColor.red  // Progress 0
        let endColor = UIColor.green  // Progress 1

        // Extract RGB components from the start and end colors
        var startRed: CGFloat = 0, startGreen: CGFloat = 0, startBlue: CGFloat = 0, startAlpha: CGFloat = 0
        var endRed: CGFloat = 0, endGreen: CGFloat = 0, endBlue: CGFloat = 0, endAlpha: CGFloat = 0
        
        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        // Interpolate each component based on the progress
        let red = startRed + (endRed - startRed) * CGFloat(clampedProgress)
        let green = startGreen + (endGreen - startGreen) * CGFloat(clampedProgress)
        let blue = startBlue + (endBlue - startBlue) * CGFloat(clampedProgress)
        let alpha = startAlpha + (endAlpha - startAlpha) * CGFloat(clampedProgress)
        
        // Return the interpolated color
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
