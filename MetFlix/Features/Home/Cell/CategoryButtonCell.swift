//
//  CategoryButtonCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 4.10.2024.
//

import Foundation
import UIKit



class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .lightGray.withAlphaComponent(0.2) : .clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(categoryLabel)
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1
        
        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(2)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        categoryLabel.text = title
    }
}
