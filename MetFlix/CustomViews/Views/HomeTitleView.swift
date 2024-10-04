//
//  HomeTitleView.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 4.10.2024.
//
import UIKit
import SnapKit

class HomeTitleView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let categories = ["TV Shows", "Movies", "Categories"]
    
    var backgroundView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let backgroundView = backgroundView {
                insertSubview(backgroundView, at: 0)
                backgroundView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    let forYouLabel: UILabel = {
        let label = UILabel()
        label.text = "For You"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "shareplay"), for: .normal)
        button.tintColor = .label
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .label
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        button.tintColor = .label
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 120, height: 40)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var collectionViewHeightConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews(topStackView, collectionView)
        
        topStackView.addArrangedSubview(forYouLabel)
        topStackView.addArrangedSubview(UIView())
        
        topStackView.addArrangedSubview(shareButton)
        topStackView.addArrangedSubview(downloadButton)
        topStackView.addArrangedSubview(searchButton)
        
        
        let buttonSize: CGFloat = 30
        shareButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonSize)
        }
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonSize)
        }
        downloadButton.snp.makeConstraints { make in
            make.width.height.equalTo(buttonSize)
        }
        
        topStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.equalTo(ScreenSize.width)
            self.collectionViewHeightConstraint = make.height.equalTo(30).constraint
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func hideCollectionView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.collectionView.alpha = 0
            self.collectionViewHeightConstraint?.update(offset: 0)
            self.layoutIfNeeded()
        }
    }
    
    func showCollectionView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.collectionView.alpha = 1
            self.collectionViewHeightConstraint?.update(offset: 30)
            self.layoutIfNeeded()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.configure(with: categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: \(categories[indexPath.row])")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = categories[indexPath.row]
        let width = category.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width + 32
        return CGSize(width: width, height: 24)
    }
}

