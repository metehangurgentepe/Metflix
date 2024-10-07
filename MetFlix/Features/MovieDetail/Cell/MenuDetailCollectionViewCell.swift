//
//  MenuDetailCollectionViewCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 7.10.2024.
//

import UIKit

class MenuCellDetail: UICollectionViewCell {
    static let identifier: String = "MenuDetailCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline).withSize(16)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "Menu Item"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? .white : .gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
