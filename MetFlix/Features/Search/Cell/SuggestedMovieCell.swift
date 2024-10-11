//
//  SuggestedMovieCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 4.10.2024.
//

import UIKit

class SuggestedMovieCell: UITableViewCell {
    static let identifier = "SuggestedMovieCell"
    
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let title : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "play.circle")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(playButton)
        
        image.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().inset(6)
            make.width.equalTo(150)
        }
        
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(image.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.lessThanOrEqualTo(50)
            make.trailing.equalToSuperview()
            make.width.lessThanOrEqualTo(50)
        }
    }
    
    func configure(movie:Movie) {
        image.sd_setImage(with: movie.backdropURL)
        title.text = movie.title
    }
}
