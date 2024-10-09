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
            updateImage()
        }
    }
    
    var verticalTitle: String? {
        didSet {
            setTitle(verticalTitle, for: .normal)
            invalidateIntrinsicContentSize()
        }
    }
    
    private var isCheckmark = false
    private let imageContainerView = UIView()
    private let image = UIImageView()

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
        titleLabel?.font = .systemFont(ofSize: 12)
        titleLabel?.textColor = .label
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
        self.tintColor = .white
        
        addSubview(imageContainerView)
        imageContainerView.addSubview(image)
        image.contentMode = .scaleAspectFit

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        imageContainerView.isUserInteractionEnabled = true
        imageContainerView.addGestureRecognizer(tapGesture)
        
        updateImage()
    }
    
    private func updateImage() {
        image.image = verticalImage
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel else { return }
        
        let spacing: CGFloat = 8
        let totalHeight = bounds.height
        let imageHeight = totalHeight * 0.6
        let titleHeight = totalHeight * 0.3
        
        imageContainerView.frame = CGRect(
            x: 0,
            y: (totalHeight - imageHeight - spacing - titleHeight) / 2,
            width: bounds.width,
            height: imageHeight
        )
        
        image.frame = imageContainerView.bounds
        
        titleLabel.frame = CGRect(
            x: 0,
            y: imageContainerView.frame.maxY + spacing,
            width: bounds.width,
            height: titleHeight
        )
        
        if let image = verticalImage {
            let aspectRatio = image.size.width / image.size.height
            let newWidth = min(imageHeight * aspectRatio, bounds.width)
            let newHeight = newWidth / aspectRatio
            self.image.frame = CGRect(
                x: (bounds.width - newWidth) / 2,
                y: (imageHeight - newHeight) / 2,
                width: newWidth,
                height: newHeight
            )
        }
    }
    
    func animatedRotation() {
        imageContainerView.layer.removeAnimation(forKey: "rotationAnimation")
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = isCheckmark ? -CGFloat.pi / 2 : CGFloat.pi / 2
        animation.duration = 0.2
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        imageContainerView.layer.add(animation, forKey: "rotationAnimation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animation.duration) {
            self.changeImage()
            self.imageContainerView.layer.removeAnimation(forKey: "rotationAnimation")
            self.imageContainerView.transform = .identity
        }
    }
    
    private func changeImage() {
        if isCheckmark {
            verticalImage = UIImage(systemName: "plus")
        } else {
            verticalImage = UIImage(systemName: "checkmark")
        }
        isCheckmark.toggle()
        updateImage()
    }
    
    @objc private func buttonTapped() {
        sendActions(for: .touchUpInside)
    }
}
