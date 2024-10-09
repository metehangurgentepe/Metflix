//
//  ProfileCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 8.10.2024.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    static let identifier = "ProfileCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override func layoutSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
    }
    
    func configure(name: String, image: UIImage?) {
        imageView.image = image
        nameLabel.text = name
    }
}
