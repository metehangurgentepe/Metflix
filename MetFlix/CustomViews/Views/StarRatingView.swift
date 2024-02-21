//
//  StarRatingView.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 10.02.2024.
//

import Foundation
import UIKit

class StarRatingView: UIView {
    private var starImageViews: [UIImageView] = []

    var rating: Double = 0.0 {
        didSet {
            updateRating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStars()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStars()
    }

    private func setupStars() {
        for _ in 0..<5 {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = .orange
            starImageViews.append(starImageView)
            addSubview(starImageView)
        }

        updateRating()
    }

    private func updateRating() {
        let filledStars = Int(rating / 2.0)
        let remainder = rating.truncatingRemainder(dividingBy: 2.0)

        for (index, starImageView) in starImageViews.enumerated() {
            if index < filledStars {
                starImageView.image = UIImage(systemName: "star.fill")
            } else if index == filledStars && remainder > 0 {
                starImageView.image = UIImage(systemName: "star.lefthalf.fill")
            } else {
                starImageView.image = UIImage(systemName: "star")
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let starSize = CGSize(width: bounds.height, height: bounds.height)
        let spacing: CGFloat = 4.0
        var starOrigin = CGPoint(x: 0, y: 0)

        for starImageView in starImageViews {
            starImageView.frame = CGRect(origin: starOrigin, size: starSize)
            starOrigin.x += starSize.width + spacing
        }
    }
}
