//
//  SimilarMovieCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 14.02.2024.
//

import UIKit

class SimilarMovieCell: UICollectionViewCell {
    static let identifier = "SimilarCell"
        
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark")
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
        label.lineBreakMode = .byTruncatingTail
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
        NetworkManager.shared.downloadImage(from:(movie.posterURL)) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async{
                if let image = image{
                    let scaledImage = UIImage(cgImage: image.cgImage!, scale: 0.2, orientation: image.imageOrientation)
                    self.imageView.image = scaledImage
                }
            }
        }
    }
    
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
