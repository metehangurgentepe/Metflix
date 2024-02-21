//
//  UIHelper.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 12.02.2024.
//

import Foundation
import UIKit

enum UIHelper {
    
    static func createThreeColumntFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth =  availableWidth / 3
        
        let photoWidth = 780
        let scale = photoWidth / Int(itemWidth)
        let itemHeight: CGFloat = CGFloat(1180 / scale)
       
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        return flowLayout
    }
}
