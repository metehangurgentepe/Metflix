//
//  CollectionViewHeaderStack.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 8.02.2024.
//

import UIKit

class CollectionViewHeaderStack: UIView {

    let stackView = UIStackView()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.text = "Header"
        return label
    }()
    
    let seeAllButton : UIButton = {
        let button = UIButton()
        button.setTitle("See All", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline).withSize(12)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(title: String, action: UIAction) {
        self.init(frame: .zero)
        titleLabel.text = title
        seeAllButton.addAction(action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(seeAllButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        
        stackView.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
    }
}
