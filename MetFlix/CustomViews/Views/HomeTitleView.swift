//
//  HomeTitleView.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 4.10.2024.
//
import UIKit
import SnapKit

protocol HomeTitleViewDelegate: AnyObject {
    func navigateSearch()
    func navigateSelectCategoryVC()
}

class HomeTitleView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let categories = ["Series", "Movies", "Categories"]
    
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
        let layout = AnimatedCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 120, height: 30)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.register(XButtonCollectionViewCell.self, forCellWithReuseIdentifier: XButtonCollectionViewCell.identifier)
        collectionView.register(AllCategoriesCollectionViewCell.self, forCellWithReuseIdentifier: AllCategoriesCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var collectionViewHeightConstraint: Constraint?
    
    var selectedIndexPath: IndexPath?
    var isSpecialViewVisible: Bool = false
    
    weak var delegate: HomeTitleViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
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
            make.height.equalTo(45)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.equalTo(ScreenSize.width)
            self.collectionViewHeightConstraint = make.height.equalTo(30).constraint
            make.bottom.equalToSuperview().offset(-2)
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
    
    @objc func searchButtonTapped() {
        delegate?.navigateSearch()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedIndexPath != nil ? 3 : categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let selectedIndexPath = selectedIndexPath {
            switch indexPath.item {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XButtonCollectionViewCell.identifier, for: indexPath) as! XButtonCollectionViewCell
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
                cell.configure(with: categories[selectedIndexPath.item],isSelected: true)
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllCategoriesCollectionViewCell.identifier, for: indexPath) as! AllCategoriesCollectionViewCell
                return cell
            default:
                fatalError("Unexpected indexPath")
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.configure(with: categories[indexPath.row],isSelected: false)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndexPath = nil
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexPath == nil {
            if indexPath.item != 2 {
                selectedIndexPath = indexPath
                collectionView.performBatchUpdates({
                    collectionView.reloadSections(IndexSet(integer: 0))
                }, completion: { _ in
                    if let selectedCell = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as? CategoryCollectionViewCell {
                        selectedCell.isSelected = true
                    }
                })
            } else {
                self.delegate?.navigateSelectCategoryVC()
            }
        } else {
            if indexPath.item == 0 {
                selectedIndexPath = nil
                collectionView.performBatchUpdates({
                    collectionView.reloadSections(IndexSet(integer: 0))
                }, completion: nil)
            } else if indexPath.item == 2 {
                self.delegate?.navigateSelectCategoryVC()
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if selectedIndexPath != nil {
            switch indexPath.item {
            case 0:
                return CGSize(width: 30, height: 30)
                
            case 1:
                let category = categories[selectedIndexPath!.item]
                let width = category.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width + 32
                return CGSize(width: width, height: 30)
                
            case 2:
                return CGSize(width: 140, height: 30)
                
            default:
                return .zero
            }
        } else {
            let category = categories[indexPath.item]
            let width = category.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .medium)]).width + 32
            return CGSize(width: width, height: 30)
        }
    }
    
}


class AnimatedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        if itemIndexPath.item == 0 {
            attributes?.alpha = 0.0
            attributes?.transform = CGAffineTransform(translationX: -30, y: 0)
        }
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        if itemIndexPath.item == 0 {
            attributes?.alpha = 0.0
            attributes?.transform = CGAffineTransform(translationX: -30, y: 0)
        }
        
        return attributes
    }
}
