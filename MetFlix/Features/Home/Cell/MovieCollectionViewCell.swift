//
//  MovieCollectionViewCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 16.02.2024.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let recommendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .white
        button.setTitle("Recommend", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.backgroundColor = .customDarkGray
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let maskPath = UIBezierPath(roundedRect: recommendButton.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 2, height: 2))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        recommendButton.layer.mask = shape
    }
    
    
    func configure(movie: Movie, isRecommended: Bool) {
        posterImageView.sd_setImage(with: movie.posterURL)
        
        if isRecommended {
            let maskPath = UIBezierPath(roundedRect: posterImageView.bounds,
                                        byRoundingCorners: [.topLeft, .topRight],
                                        cornerRadii: CGSize(width: 4, height: 4))
            
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            posterImageView.layer.mask = shape
            
            posterImageView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview().inset(30)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
            
            contentView.addSubview(recommendButton)
            recommendButton.snp.makeConstraints { make in
                make.top.equalTo(posterImageView.snp.bottom)
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(30)
            }
        } else {
            posterImageView.layer.cornerRadius = 6
        }
    }
}
