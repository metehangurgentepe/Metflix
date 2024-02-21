//
//  Header.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 17.02.2024.
//

import UIKit

class Header: UITableViewHeaderFooterView {
    
    let stackView = UIStackView()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
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
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    convenience init(title: String, action: UIAction) {
        self.init(reuseIdentifier: nil)
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
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
}
