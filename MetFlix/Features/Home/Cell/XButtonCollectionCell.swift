//
//  XButtonCollectionCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 7.10.2024.
//

import Foundation
import UIKit

class XButtonCollectionViewCell: UICollectionViewCell {
    static let identifier = "XButtonCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "xmark"))
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
