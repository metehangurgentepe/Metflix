//
//  CategoryButtonCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 3.10.2024.
//
import Foundation
import UIKit

class CapsuleLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius: CGFloat = bounds.height / 2
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.borderWidth = 1
    }
}

class CategoryButtonCell: UICollectionViewCell {
    private let label = CapsuleLabel()
    private let iconImageView = UIImageView()
    private let textLabel = UILabel()
    private let stackView = UIStackView()

    static let identifier = "CategoryButtonCell"
    var title: String?
    private var icon = UIImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            configure(title: title ?? "", icon: icon)
        }
    }
    
    func setupUI() {
        addSubview(label)
        label.addSubview(stackView)

        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(textLabel)

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(title: String, icon: UIImage?) {
        self.title = title
        self.iconImageView.image = icon
        self.icon = icon ?? UIImage()
        
        textLabel.font = .preferredFont(forTextStyle: .headline).withSize(16)
        textLabel.text = title
        textLabel.textColor = isSelected ? .black : .white
        
        iconImageView.tintColor = isSelected ? .black : .white
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16) 
        }
        
        label.backgroundColor = isSelected ? .white : .black
    }
}
