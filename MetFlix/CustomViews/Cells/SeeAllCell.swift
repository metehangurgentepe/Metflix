//
//  SeeAllCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 13.02.2024.
//

import UIKit

class SeeAllCell: UICollectionViewCell {
    static let identifier = "SeeAllCell"
    
    lazy var imageView: UIImageView = {
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
        let lowResPosterURL = movie.posterURL.absoluteString.replacingOccurrences(of: "w780", with: "w300")
        imageView.sd_setImage(with: URL(string: lowResPosterURL), placeholderImage: nil, options: .continueInBackground, context: nil)
    }
    
    
    private func setupUI() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
