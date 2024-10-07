//
//  MovieDetailCategoryController.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 7.10.2024.
//
import Foundation
import UIKit

protocol MenuDetailControllerDelegate: AnyObject {
    func didTapMenuItem(indexPath: IndexPath)
}

class MenuDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate var menuItems = [
        "Similars",
        "Recommendations"
        ]
    
    var menuBar: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    weak var delegate: MenuDetailControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MenuCellDetail.self, forCellWithReuseIdentifier: MenuCellDetail.identifier)
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        
        view.addSubview(menuBar)
        
        view.bringSubviewToFront(menuBar)
        
        menuBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(4)
            make.width.equalTo(100)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapMenuItem(indexPath: indexPath)
        
        guard let selectedCell = collectionView.cellForItem(at: indexPath) else { return }
        
        let cellFrame = selectedCell.frame
        
        self.menuBar.snp.remakeConstraints { make in
            make.leading.equalTo(cellFrame.origin.x)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(4)
            make.width.equalTo(0)
        }
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.0, options: .curveEaseIn) {
            self.menuBar.snp.updateConstraints { make in
                make.width.equalTo(cellFrame.width)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuDetailCell", for: indexPath) as! MenuCellDetail
        cell.label.text = menuItems[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = menuItems[indexPath.item]
        let cellWidth = text.size(withAttributes:[.font: UIFont.preferredFont(forTextStyle: .headline).withSize(18)]).width
        
        menuBar.snp.makeConstraints { make in
            make.width.equalTo(cellWidth)
        }
        
        return .init(width: cellWidth, height: view.frame.height)
    }
}
