import Foundation
import UIKit

public class ContextController: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addCustomView()
    }
    
    private func addCustomView() {
        let customView = CustomView(frame: CGRect(x: 50, y: 50, width: 300, height: 300))
        customView.backgroundColor = .white
        customView.layer.borderWidth = 2.0
        customView.layer.borderColor = UIColor.black.cgColor
        view.addSubview(customView)
    }

}

class CustomView: UIView {
    
    let degreesToRadian: (CGFloat) -> CGFloat = {
        return $0 / 180 * CGFloat.pi
    }
    
    override func draw(_ rect: CGRect) {
        drawRectangle(CGRect(x: 0, y: 0, width: 100, height: 50))
    }
    
    private func drawCircleWithPlus(_ rect: CGRect) {
        var path = UIBezierPath(ovalIn: rect)
        UIColor.blue.setFill()
        path.fill()
        
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        var plusPath = UIBezierPath()
        plusPath.lineWidth = plusHeight
        plusPath.move(to: CGPoint(x: bounds.width / 2 - plusWidth / 2 + 0.5, y: bounds.height / 2 + 0.5))
        plusPath.addLine(to: CGPoint(x: bounds.width / 2 + plusWidth / 2 + 0.5, y: bounds.height / 2 + 0.5))
        
        plusPath.move(to: CGPoint(x: bounds.width / 2 + 0.5, y: bounds.height / 2 - plusWidth / 2 + 0.5))
        plusPath.addLine(to: CGPoint(x: bounds.width / 2 + 0.5, y: bounds.height / 2 + plusWidth / 2 + 0.5))
        
        UIColor.white.setStroke()
        plusPath.stroke()
    }
    
    private func drawRectangle(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let redImage = getImageWithColor(color: .red, size: rect.size)
        context?.draw(redImage.cgImage!, in: rect)
        
        let blueImage = getImageWithColor(color: .blue, size: rect.size)
//        context?.translateBy(x: rect.width / 2, y: rect.height / 2)
        context?.rotate(by: degreesToRadian(45))
//        context?.translateBy(x: -rect.width / 2, y: -rect.height / 2)
        context?.draw(blueImage.cgImage!, in: rect)
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
