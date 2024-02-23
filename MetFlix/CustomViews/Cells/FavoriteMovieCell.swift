//
//  FavoriteMovieCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 12.02.2024.
//

import UIKit

class FavoriteMovieCell: UICollectionViewCell {
    static let identifier = "FavoriteCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = SFSymbols.question
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .headline).withSize(14)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(movie: Movie) {
        nameLabel.text = movie.title
        imageView.sd_setImage(with: movie.posterURL)
    }
    
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
