//
//  HomeCollectionView.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 27.01.2024.
//

import Foundation
import UIKit

class NowPlayingCell: UICollectionViewCell{
    
    static let identifier = "NowPlayingCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with image: UIImage) {
        self.imageView.image = image
    }
    
    func set(movie: Movie) {
        nameLabel.text = movie.title
        NetworkManager.shared.downloadImage(from:movie.backdropURL) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async{
                self.imageView.image = image
            }
        }
    }
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
