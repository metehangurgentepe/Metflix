//
//  UIImage+Ext.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 8.02.2024.
//

import Foundation
import UIKit


extension UIImage {
    
    func resized(to targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?
            CGSize(width: size.width * heightRatio, height: size.height * heightRatio) :
            CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: rect)

        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
