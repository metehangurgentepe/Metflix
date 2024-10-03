//
//  NewsAndPopularTableViewCell.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 2.10.2024.
//

import UIKit
import SnapKit

class NewsAndPopularTableViewCell: UITableViewCell {
    static let identifier = "NewsAndPopularTableViewCell"
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        return stack
    }()
    
    lazy var remindMeButton = VerticalButton()
    
    lazy var infoButton = VerticalButton()
    
    lazy var recommendedButton = VerticalButton(frame: .zero)
    
    lazy var addListButton = VerticalButton()
    
    lazy var playButton = VerticalButton()
    
    
    let productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 4
        return label
    }()
    
    let genreLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private var dateLabelTopConstraint: Constraint?
    private var dateLabelInitialTop: CGFloat = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        remindMeButton.verticalImage = UIImage(systemName: "bell")
        remindMeButton.verticalTitle = "Remind Me"
        
        infoButton.verticalImage = UIImage(systemName: "info.circle")
        infoButton.verticalTitle = "Info"
        
        recommendedButton.verticalImage = UIImage(systemName: "paperplane")
        recommendedButton.verticalTitle = "Recommend"
        
        playButton.verticalImage = UIImage(systemName: "play.fill")
        playButton.verticalTitle = "Play"
        
        addListButton.verticalImage = UIImage(systemName: "plus")
        addListButton.verticalTitle = "My List"
        
        buttonStackView.spacing = 4
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(buttonStackView)
        
        dateLabel.snp.makeConstraints { make in
            self.dateLabelTopConstraint = make.top.equalToSuperview().constraint
            make.height.equalTo(40)
            make.width.equalTo(36)
            make.leading.equalToSuperview().offset(6)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(4)
            make.leading.equalTo(productTitleLabel.snp.leading)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.trailing).offset(0)
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        productTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.leading.equalTo(thumbnailImageView.snp.leading)
            make.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(productTitleLabel.snp.bottom)
            make.leading.equalTo(productTitleLabel.snp.leading)
            make.height.lessThanOrEqualTo(200)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.leading.equalTo(overviewLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    
    
    func configure(movie: Movie?, index: Int?, wide: Bool, upcoming: Bool, series: Series?) {
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if let movie = movie {
            configureForMovie(movie: movie, index: index, wide: wide, upcoming: upcoming)
        } else if let series = series {
            configureForSeries(series: series, index: index)
        }
    }

    private func configureForMovie(movie: Movie, index: Int?, wide: Bool, upcoming: Bool) {
        if upcoming {
            configureUpcomingMovie(movie: movie, wide: wide)
        } else {
            configureRegularMovie(movie: movie, index: index, wide: wide)
        }
        
        titleLabel.text = movie.title
        thumbnailImageView.sd_setImage(with: movie.posterURL)
        overviewLabel.text = movie.overview
        productTitleLabel.text = movie.title
        
        buttonStackView.layoutIfNeeded()
    }

    private func configureUpcomingMovie(movie: Movie, wide: Bool) {
        buttonStackView.addArrangedSubview(remindMeButton)
        buttonStackView.addArrangedSubview(infoButton)
        
        buttonStackView.spacing = 4
        buttonStackView.distribution = .fillEqually
        
        dateLabel.attributedText = getReleaseDate(date: movie.releaseDate ?? "")
        dateLabel.isHidden = false
        
        if !wide {
            thumbnailImageView.snp.updateConstraints { make in
                make.leading.equalToSuperview().offset(40)
            }
        }
    }

    private func configureRegularMovie(movie: Movie, index: Int?, wide: Bool) {
        buttonStackView.addArrangedSubview(recommendedButton)
        buttonStackView.addArrangedSubview(addListButton)
        buttonStackView.addArrangedSubview(playButton)
        
        recommendedButton.snp.makeConstraints { make in
            make.width.equalTo(ScreenSize.width - 120).multipliedBy(0.5)
        }
        
        buttonStackView.spacing = 1
        buttonStackView.distribution = .fillEqually
        
        if wide {
            dateLabel.isHidden = true
            thumbnailImageView.snp.updateConstraints { make in
                make.leading.equalToSuperview().offset(4)
            }
        } else {
            if let index = index {
                dateLabel.isHidden = false
                dateLabel.text = "\(index)"
                thumbnailImageView.snp.updateConstraints { make in
                    make.leading.equalToSuperview().offset(40)
                }
            }
        }
    }

    private func configureForSeries(series: Series, index: Int?) {
        if let index = index {
            dateLabel.isHidden = false
            dateLabel.text = "\(index)"
            thumbnailImageView.snp.updateConstraints { make in
                make.leading.equalToSuperview().offset(40)
            }
        }
        
        buttonStackView.addArrangedSubview(recommendedButton)
        buttonStackView.addArrangedSubview(addListButton)
        buttonStackView.addArrangedSubview(playButton)
        
        buttonStackView.spacing = 1
        buttonStackView.distribution = .fillEqually
        
        titleLabel.text = series.name
        thumbnailImageView.sd_setImage(with: series.posterURL)
        overviewLabel.text = series.overview
        productTitleLabel.text = series.originalName
    }

    
    
    func getReleaseDate(date: String) -> NSMutableAttributedString {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let releaseDate = dateFormatter.date(from: date) else {
            dateLabel.text = "Bilinmeyen Tarih"
            return NSMutableAttributedString()
        }
        
        dateFormatter.dateFormat = "MMM"
        dateFormatter.locale = Locale.current
        let monthString = dateFormatter.string(from: releaseDate)
        
        dateFormatter.dateFormat = "dd"
        let dayString = dateFormatter.string(from: releaseDate)
        
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: monthString, attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .regular)
        ]))
        attributedString.append(NSAttributedString(string: "\n", attributes: [:])) 
        attributedString.append(NSAttributedString(string: dayString, attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold)
        ]))
        
        return attributedString
    }
    
    func updateDateLabelPosition(progress: CGFloat) {
        let maxOffset = self.frame.height - dateLabel.frame.height
        let newTopOffset = progress * maxOffset
        dateLabelTopConstraint?.update(offset: newTopOffset)
    }
}
