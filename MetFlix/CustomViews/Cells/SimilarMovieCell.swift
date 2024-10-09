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
        imageView.image = SFSymbols.question
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(movie: Movie) {
        imageView.sd_setImage(with: movie.lowResolutionPosterURL)
    }
    
    
    private func setupUI() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
