//
//  HorizontalMobileCollectionViewCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 4.10.2024.
//

import UIKit

class HorizontalMobileCollectionViewCell: UICollectionViewCell {
    static let identifier = "HorizontalMobileCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline).withSize(12)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(posterImageView.snp.width)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(2)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func configure(movie: Movie) {
        posterImageView.sd_setImage(with: movie.posterURL)
        titleLabel.text = movie.title
    }
}
