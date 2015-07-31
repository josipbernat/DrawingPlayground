import UIKit
import XCPlayground

//: Type Value models: Each struct conforms to Drawable protocol in order to draw it self.

//MARK: - Circle

public struct Circle: Drawable {
    
    var radius: CGFloat = 0.0
    var center: CGPoint
    var lineColor: UIColor = UIColor.whiteColor()
    var lineWidth: CGFloat = 1.0
    var fillColor: UIColor = UIColor.clearColor()
    
    var frame: CGRect {
        get { return CGRectMake(center.x - radius, center.y - radius, radius * 2.0, radius * 2.0) }
    }
    
    public func draw(renderer: Renderer) {

        // Set arc attributes
        renderer.setLineWidth(lineWidth)
        renderer.setStrokeColor(lineColor)
        renderer.setFillColor(fillColor)
        
        // Render arc
        renderer.arcAt(center, radius: radius, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0))
        renderer.closePath()
    }
}

extension Circle: Equatable {}

public func == (lhs: Circle, rhs: Circle) -> Bool {
    return true
}

//MARK: - Polygon

public struct Polygon: Drawable {
    
    var corners: [CGPoint] = []
    var lineColor: UIColor = UIColor.whiteColor()
    var lineWidth: CGFloat = 1.0
    var fillColor: UIColor = UIColor.clearColor()

    public func draw(renderer: Renderer) {
        
        // Set arc attributes
        renderer.setStrokeColor(lineColor)
        renderer.setLineWidth(lineWidth)
        renderer.setFillColor(fillColor)
        
        // Move point
        renderer.moveTo(corners.last!)
        
        for corner in corners {
            renderer.lineTo(corner)
        }
        
        renderer.closePath()
    }
}

extension Polygon: Equatable {}

public func == (lhs: Polygon, rhs: Polygon) -> Bool {
    return true
}

//MARK: - Diagram

public struct Diagram: Drawable {
    
    var elements: [Drawable] = []
    
    public func draw(renderer: Renderer) {
        
        for element in elements {
            element.draw(renderer)
        }
    }
}

//: Renderer which is user as a bridge to CoreGraphics.

//MARK: - View Renderer

struct ViewRenderer: Renderer {

    var context: CGContextRef!
    
    func moveTo(p: CGPoint) {
        context.moveTo(p)
    }
    
    func lineTo(p: CGPoint) {
        context.lineTo(p)
    }

    func closePath() {
        context.closePath()
    }
    
    func arcAt(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        context.arcAt(center, radius: radius, startAngle: startAngle, endAngle: endAngle)
    }
    
    func setLineWidth(width: CGFloat) {
        context.setLineWidth(width)
    }
    
    func setStrokeColor(color: UIColor) {
        context.setStrokeColor(color)
    }
    
    func setFillColor(color: UIColor) {
        context.setFillColor(color)
    }
}

//MARK: - Drawing
let drawingArea = CGRect(x: 0.0, y: 0.0, width: 375.0, height: 500.0)

/// Shows a `UIView` in the current playground that draws itself by invoking
/// `draw` on a `CGContext`, then stroking the context's current path in a
/// pleasing light blue.
func showCoreGraphicsDiagram(title: String, draw: (CGContext)->()) {
    
    let diagramView = CoreGraphicsView(frame: drawingArea)
    diagramView.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0)
    diagramView.draw = draw
    diagramView.setNeedsDisplay()
    
    XCPShowView(title, view: diagramView)
}

//: Testing area

//MARK: - Test

var circle1 = Circle(radius: 55.0, center: CGPointMake(107.5, 190.0), lineColor: UIColor.whiteColor(), lineWidth: 5.0, fillColor: UIColor.yellowColor())

var circle2 = Circle(radius: 55.0, center: CGPointMake(267.5, 190.0), lineColor: UIColor.whiteColor(), lineWidth: 14.0, fillColor: UIColor.yellowColor())

var points: [CGPoint] = [CGPointMake(67.5, 250.0), CGPointMake(187.5, 342.0), CGPointMake(307.5, 250.0), CGPointMake(187.5, 370.0)]

var polygon = Polygon(corners: points, lineColor: UIColor.yellowColor(), lineWidth: 2.0, fillColor: UIColor.purpleColor())

var diagram = Diagram(elements: [circle1, circle2, polygon])
var renderer = ViewRenderer(context: nil)

showCoreGraphicsDiagram("Drawing board", draw: { (context) -> () in
    renderer.context = context
    diagram.draw(renderer)
})
