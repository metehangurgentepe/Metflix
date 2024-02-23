//
//  CarouselCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.02.2024.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    
    static var identifier: String = "CarouselCell"
    
    let imageView: UIImageView = UIImageView(image: Images.defaultPhoto)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(imageUrl: URL ) {
        imageView.sd_setImage(with: imageUrl)
    }
    
    private func setupImageView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.addSubview(self.imageView)
            self.imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            self.imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
