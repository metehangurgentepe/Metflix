//
//  ProfileButtonTableViewCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//

import UIKit

struct ProfileCellModel {
    let color: UIColor
    let title: String
    let icon: UIImage
}

class ProfileButtonTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileButtonTableViewCell"
    
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        return imageView
    }()
    
    let circularImageView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .heavy)
        label.textColor = .label
        return label
    }()
    
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func layoutSubviews() {
        contentView.addSubview(circularImageView)
        contentView.addSubview(title)
        contentView.addSubview(icon)
        
        circularImageView.addSubview(image)
        
        circularImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.height.width.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(circularImageView.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.height.width.equalTo(15)
        }
        
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(color: UIColor, image: UIImage, title: String) {
        circularImageView.backgroundColor = color
        self.image.image = image
        self.title.text = title
    }
}
