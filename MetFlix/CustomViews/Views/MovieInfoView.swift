//
//  MovieInfoView.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 10.02.2024.
//

import UIKit

class MovieInfoView: UIView {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "2012"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let runtimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "120"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline).withSize(20)
        return label
    }()
    
    let ageView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 4
        
        let label = UILabel()
        label.text = "18+"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 8)
        
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(12)
        }
        
        return view
    }()
    
    var hStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        sv.distribution = .fillProportionally
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(movie: Movie) {
        print(movie)
        dateLabel.text = movie.yearText
        runtimeLabel.text = movie.runtime!.description + " min"
        nameLabel.text = movie.title
    }
    
    private func configure() {
        addSubview(nameLabel)
        addSubview(hStackView)
        
        hStackView.addArrangedSubview(dateLabel)
        hStackView.addArrangedSubview(ageView)
        hStackView.addArrangedSubview(runtimeLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
            make.top.equalToSuperview()
        }
        
        hStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.width.lessThanOrEqualTo(150)
            make.height.equalTo(20)
        }
    }
}
