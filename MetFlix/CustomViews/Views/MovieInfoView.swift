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
        label.textColor = .secondaryLabel
        label.text = "2012"
        return label
    }()
    
    let runtimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "120"
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        //        label.font = .preferredFont(forTextStyle: .)
        return label
    }()
    
    let imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "lane")
        return imageview
    }()
    
    let imageView2: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "lane")
        return imageview
    }()
    
    let verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        view.frame.size = CGSize(width: 3, height: 50)
        return view
    }()
    
    let verticalLine2: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        view.frame.size = CGSize(width: 3, height: 50)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(movie:Movie) {
        print(movie)
        dateLabel.text = movie.yearText
        runtimeLabel.text = movie.runtime!.description + " min"
        genreLabel.text = movie.genres?.first?.name ?? ""
    }
    
    private func configure() {
        var line = verticalLine
        
        line.snp.makeConstraints { make in
            make.width.equalTo(3)
            make.height.equalTo(50)
        }
        
        var line2 = verticalLine2
        
        line2.snp.makeConstraints { make in
            make.width.equalTo(3)
            make.height.equalTo(50)
        }
        
        let horizontalStackView = UIStackView(arrangedSubviews: [dateLabel, line, runtimeLabel, line2, genreLabel])
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 10
        
        
        addSubview(horizontalStackView)
        
        horizontalStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
