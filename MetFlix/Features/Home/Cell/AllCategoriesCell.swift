//
//  AllCategoriesCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 7.10.2024.
//

import Foundation
import UIKit
class AllCategoriesCollectionViewCell: UICollectionViewCell {
    static let identifier = "AllCategoriesCollectionViewCell"
    
    let allCategoriesLabel: UILabel = {
        let label = UILabel()
        label.text = "All Categories"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .gray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(allCategoriesLabel)
        addSubview(chevronImageView)
        
        allCategoriesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.leading.equalTo(allCategoriesLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
    }
}
