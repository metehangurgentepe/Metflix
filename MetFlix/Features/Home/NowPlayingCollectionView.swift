//
//  HomeCollectionView.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 27.01.2024.
//

import Foundation
import UIKit

class NowPlayingCollectionView: UICollectionViewCell{
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private func setupCell(with movie: Movie) {
        imageView.image = UIImage(named: movie.backdropPath ?? "")
        nameLabel.text = movie.title
    }
    
    // UICollectionViewCell'in öğelerini ayarlamak için init metodu
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            // İmageView ve Label'ı ekleyin
            addSubview(imageView)
            addSubview(nameLabel)
            
            // Constraints'leri ayarlayın (örneğin, resim ve metin arasında boşluk bırakmak için)
            imageView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.bottom.equalTo(nameLabel.snp.top).offset(-8) // Metin ile resim arasında boşluk bırakın
            }
            
            nameLabel.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(20) // Sabit bir yükseklik ayarlayın
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
