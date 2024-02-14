//
//  HeaderImageView.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.02.2024.
//

import UIKit

class CustomUIView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        return imageView
    }()

}
