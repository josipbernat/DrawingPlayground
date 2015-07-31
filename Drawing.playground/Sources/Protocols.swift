import UIKit

//MARK: - Renderer

public protocol Renderer {
    
    // Shape drawing
    func moveTo(p: CGPoint)
    func lineTo(p: CGPoint)
    func closePath()
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat)
    
    // Shape apperance
    func setLineWidth(width: CGFloat)
    func setStrokeColor(color: UIColor)
    func setFillColor(color: UIColor)
}

//MARK: - Drawable

public protocol Drawable {
    func draw(renderer: Renderer)
}
