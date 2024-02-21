//
//  MovieCollectionViewCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 16.02.2024.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
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
    }
    
    func configure(movie: Movie) {
        NetworkManager.shared.downloadImage(from:(movie.posterURL)) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async{
                if let image = image{
                    self.posterImageView.image = image
                }
            }
        }
    }
    
    
}
