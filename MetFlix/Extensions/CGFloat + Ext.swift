//
//  CGFloat + Ext.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 16.02.2024.
//

import Foundation
import UIKit

extension UIViewController {
    var screenWidth: CGFloat {
        return view.frame.size.width
    }
    
    var screenHeight: CGFloat {
        return view.frame.size.height
    }
}

extension UIView {
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
