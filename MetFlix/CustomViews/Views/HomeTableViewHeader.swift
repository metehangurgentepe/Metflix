//
//  HomeTableViewHeader.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 4.10.2024.
//
import UIKit

class HomeTableViewHeader: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    let movieLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.text = "FILM"
        return label
    }()
    
    let playButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = .white
        button.tintColor = .black
        return button
    }()
    
    let moreInfoButton : UIButton = {
        let button = UIButton()
        button.setTitle("More Information", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 4
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let logoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        logoStackView.addArrangedSubview(logo)
        logoStackView.addArrangedSubview(movieLabel)
        
        addSubviews(imageView, playButton, moreInfoButton, titleLabel, logoStackView)
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        playButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalTo(imageView.snp.leading).offset(26)
            make.trailing.equalTo(imageView.snp.centerX).offset(-4)
            make.height.equalTo(40)
        }
        
        moreInfoButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalTo(imageView.snp.centerX).offset(4)
            make.trailing.equalTo(imageView.snp.trailing).offset(-26)
            make.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(playButton.snp.top).offset(-16)
            make.centerX.equalTo(imageView.snp.centerX)
            make.height.equalTo(50)
        }
        
        logoStackView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).offset(10)
            make.centerX.equalTo(imageView.snp.centerX)
        }
        
        logo.snp.makeConstraints { make in
            make.height.width.equalTo(30) 
        }
        
        movieLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
    
    func configure(movie: Movie) {
        imageView.sd_setImage(with: movie.posterURL)
        titleLabel.text = movie.title
    }
}
