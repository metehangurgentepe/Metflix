//
//  TopRatedCollectionViewCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 8.10.2024.
//
import UIKit
import SnapKit
import SDWebImage

class TopRatedCollectionViewCell: UICollectionViewCell {
    static let identifier = "TopRatedCollectionViewCell"
    
    private let firstDigitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "LondrinaSketch-Regular", size: 120)
        return label
    }()
    
    private let secondDigitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "LondrinaSketch-Regular", size: 120)
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var rankString: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(firstDigitLabel)
        contentView.addSubview(secondDigitLabel)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let isSingleDigit = rankString!.count == 1
        

        if isSingleDigit {
            firstDigitLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.width.lessThanOrEqualTo(40)
                make.height.equalTo(contentView.frame.height - 20)
                make.bottom.equalToSuperview()
            }
            secondDigitLabel.removeFromSuperview()
            
            posterImageView.snp.makeConstraints { make in
                make.leading.equalTo(firstDigitLabel.snp.leading).offset(40)
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        } else {
            contentView.addSubview(secondDigitLabel)
            
            firstDigitLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.width.lessThanOrEqualTo(40)
                make.height.equalTo(contentView.frame.height - 20)
                make.bottom.equalToSuperview()
            }
            
            secondDigitLabel.snp.makeConstraints { make in
                make.leading.equalTo(firstDigitLabel.snp.leading).offset(20)
                make.width.lessThanOrEqualTo(40)
                make.height.equalTo(contentView.frame.height - 20)
                make.bottom.equalToSuperview()
            }
            
            posterImageView.snp.remakeConstraints { make in
                make.leading.equalTo(secondDigitLabel.snp.leading).offset(20)
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        }
        contentView.bringSubviewToFront(posterImageView)
    }
    
    func configure(movie: Movie, rank: Int) {
        posterImageView.sd_setImage(with: movie.posterURL)

        self.rankString = "\(rank)"
        
        if rankString!.count == 1 {
            firstDigitLabel.text = rankString // Tek rakamı birinci label'a ekle
            secondDigitLabel.text = "" // İkinci label boş kalsın
        } else if rankString!.count == 2 {
            firstDigitLabel.text = String(rankString!.first!) // Birinci rakam
            secondDigitLabel.text = String(rankString!.last!) // İkinci rakam
        }
    }
}
