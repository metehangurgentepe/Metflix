//
//  VerticalButton.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 3.10.2024.
//

import UIKit

class VerticalButton: UIButton {
    
    var verticalImage: UIImage? {
        didSet {
            setImage(verticalImage, for: .normal)
        }
    }
    
    var verticalTitle: String? {
        didSet {
            setTitle(verticalTitle, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    convenience init(image: UIImage?, title: String?) {
        self.init(frame: .zero)
        self.verticalImage = image
        self.verticalTitle = title
        setupButton()
    }
    
    private func setupButton() {
        titleLabel?.font = .systemFont(ofSize: 8)
        titleLabel?.textColor = .label
        imageView?.contentMode = .scaleAspectFit
        self.tintColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        
        let imageHeight = imageView.frame.size.height
        let titleHeight = titleLabel.frame.size.height
        
        let totalHeight = imageHeight + titleHeight + 4
        imageView.center = CGPoint(x: bounds.width / 2, y: (bounds.height - titleHeight) / 2 - 4)
        titleLabel.center = CGPoint(x: bounds.width / 2, y: (bounds.height + imageHeight) / 2 + 4)
        
    }
}
