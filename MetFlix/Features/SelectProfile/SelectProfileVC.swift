//
//  SelectProfileVC.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 8.10.2024.
//

import UIKit

class SelectProfileVC: UIViewController {
    
    var collectionView: UICollectionView!
    
    var profiles: [(String, UIImage)] = []
    var selectedProfile: (String, UIImage)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Who's watching?"
        
        let editButton = UIBarButtonItem(systemItem: .edit)
        editButton.tintColor = .white
        navigationItem.rightBarButtonItem = editButton
        
        setupCollectionView()
        setupProfiles()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
        collectionView.backgroundColor = .clear
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.centerY.equalToSuperview()
            make.height.equalTo(profiles.count / 2 * 200)
        }
    }
    
    private func setupProfiles() {
        profiles = [
            ("Metehan", UIImage(named: "avatar1")!),
            ("Friend 1", UIImage(named: "avatar2")!),
            ("Friend 2", UIImage(named: "avatar3")!),
            ("Guest", UIImage(named: "avatar4")!)
        ]
        collectionView.reloadData()
        
        collectionView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(220)
            make.centerY.equalToSuperview()
            make.height.equalTo(profiles.count / 2 * 150)
        }
    }
    
    private func goToMainTabBar() {
        let tabBarVC = TabBarViewController()
        if let selectedProfile = selectedProfile {
            tabBarVC.selectedProfileImage = selectedProfile.1
        }
        tabBarVC.modalTransitionStyle = .crossDissolve
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true, completion: {
            tabBarVC.animateProfileTabIcon()
        })
    }
}

extension SelectProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        cell.configure(name: profiles[indexPath.row].0, image: profiles[indexPath.row].1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProfile = profiles[indexPath.row]
        
        goToMainTabBar()
    }
}
