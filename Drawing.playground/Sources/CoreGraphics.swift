import UIKit
import CoreGraphics

//MARK: - CoreGraphicsView

public class CoreGraphicsView : UIView {
    
    override public func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        // Save Context
        CGContextSaveGState(context)
        
        // Call draw and enable renderer for drawing.
        draw(context)
        
        // Restore Context
        CGContextRestoreGState(context)
    }
    
    public var draw: (CGContext)->() = { _ in () }
}

//MARK: - The Real Thing - Core Graphics

extension CGContext : Renderer {
    
    public func moveTo(p: CGPoint) {
        CGContextMoveToPoint(self, p.x, p.y)
    }
    
    public func lineTo(p: CGPoint) {
        CGContextAddLineToPoint(self, p.x, p.y)
    }
    
    public func closePath() {
        CGContextClosePath(self)
        CGContextDrawPath(self, kCGPathEOFillStroke)
    }
    
    public func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        
        let arc = CGPathCreateMutable()
        CGPathAddArc(arc, nil, center.x, center.y, radius, startAngle, endAngle, true)
        CGContextAddPath(self, arc)
    }
    
    public func setLineWidth(width: CGFloat) {
        CGContextSetLineWidth(self, width)
    }
    
    public func setStrokeColor(color: UIColor) {
        CGContextSetStrokeColorWithColor(self, color.CGColor)
    }
    
    public func setFillColor(color: UIColor) {
        CGContextSetFillColorWithColor(self, color.CGColor)
    }
}