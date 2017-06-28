//
//  MapOverlay.swift
//  IndoorNavigation
//
//  Created by jeff on 15/06/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit
import MapKit
import IndoorAtlas

// Class for map overlay object
class MapOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    // Initializer for the class
    init(floorPlan: IAFloorPlan) {
        coordinate = floorPlan.center
        boundingMapRect = MKMapRect()
        
        //Width and height in MapPoints for the floorplan
        let mapPointsPerMeter = MKMapPointsPerMeterAtLatitude(coordinate.latitude)
        let widthMapPoints = floorPlan.widthMeters * Float(mapPointsPerMeter)
        let heightMapPoints = floorPlan.heightMeters * Float(mapPointsPerMeter)
        
        // Area coordinates for the overlay
        let topLeft = MKMapPointForCoordinate(floorPlan.topLeft)
        boundingMapRect = MKMapRectMake(topLeft.x, topLeft.y, Double(widthMapPoints), Double(heightMapPoints))
    }
}

// Class for rendering map overlay objects
class MapOverlayRenderer: MKOverlayRenderer {
    var overlayImage: UIImage
    var floorPlan: IAFloorPlan
    
    init(overlay:MKOverlay, overlayImage:UIImage, fp: IAFloorPlan) {
        self.overlayImage = overlayImage
        self.floorPlan = fp
        // floorPlan.imageURL = "https://idaweb.blob.core.windows.net/imageblobcontainer/d8639bc5-9486-41b7-a2fb-61990bcdb829"
        // floorPlan.bearing = 59.546650481646623
        super.init(overlay: overlay)
//        self.overlayImage = self.imageRotatedByDegrees(oldImage: self.overlayImage, deg: CGFloat(fp.bearing))
//        self.overlayImage = self.overlayImage.fixedOrientation().imageRotatedByDegrees(degrees: CGFloat(fp.bearing))
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in ctx: CGContext) {
        let theMapRect = overlay.boundingMapRect
        let theRect = rect(for: theMapRect)

        // Rotate around top left corner
//        ctx.scaleBy(x: 1.0, y: -1.0)
//        ctx.translateBy(x: 0.0, y: -theRect.size.height)
        ctx.translateBy(x: theRect.size.width / 2.0, y: theRect.size.height / 2.0)
        ctx.rotate(by: CGFloat(degreesToRadians(floorPlan.bearing)));
        ctx.translateBy(x: -theRect.size.width / 2.0, y: -theRect.size.height / 2.0)
//        ctx.draw(overlayImage.cgImage!, in: theRect)

        // Draw the floorplan image
        UIGraphicsPushContext(ctx)
        overlayImage.draw(in: theRect, blendMode: CGBlendMode.color, alpha: 1.0)
        UIGraphicsPopContext();
    }
    
    // Function to convert degrees to radians
    func degreesToRadians(_ x:Double) -> Double {
        return (M_PI * x / 180.0)
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
    
    private func overlayRotatedByDegree(overlay: MKOverlay, deg degrees: CGFloat) {
        
    }
}

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
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
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    public func fixedOrientation() -> UIImage {
        if imageOrientation == UIImageOrientation.up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil,
                                       width: Int(size.width),
                                       height: Int(size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent,
                                       bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
}
