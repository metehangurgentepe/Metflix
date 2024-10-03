//
//  NewAndPopularHeader.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 3.10.2024.
//

import Foundation
import UIKit

class NewAndPopularHeader: UITableViewHeaderFooterView {
    
    let stackView = UIStackView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.text = "Header"
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    convenience init(title: String, image: UIImage) {
        self.init(reuseIdentifier: nil)
        titleLabel.text = title
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(stackView) // Header view'in içine değil, contentView'e eklemeliyiz.
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        stackView.spacing = 8 // Görsel ve başlık arasında boşluk
        stackView.alignment = .center // Elemanları dikeyde ortalar
        stackView.axis = .horizontal
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8) // Üst ve alt boşluklar
            make.leading.equalToSuperview().offset(16) // Sol boşluk
            make.trailing.equalToSuperview().offset(-16) // Sağ boşluk
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(24) // Görüntü boyutu
        }
    }
}
