//
//  SelectProfileVC.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 8.10.2024.
//

import UIKit

class SelectProfileVC: UIViewController {
    
    var collectionView: UICollectionView!
    
    var profiles: [User] = []
    var selectedProfile: (String, String)?
    
    let viewModel = SelectProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupCollectionView()
        
        viewModel.delegate = self
        viewModel.fetchUsers()
       
        setupProfiles()
    }
    
    fileprivate func configureViewController() {
        view.backgroundColor = .systemBackground
        
        title = "Who's watching?"
        
        let editButton = UIBarButtonItem(systemItem: .edit)
        editButton.tintColor = .white
        navigationItem.rightBarButtonItem = editButton
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
            tabBarVC.selectedProfileImage = UIImage(named: selectedProfile.1)
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
        cell.configure(name: profiles[indexPath.row].username ?? "", image: profiles[indexPath.row].imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = profiles[indexPath.row]
        UserSession.shared.userId = selectedUser.userID?.uuidString
        
        selectedProfile = (selectedUser.username, selectedUser.imageName) as! (String, String)
        
        goToMainTabBar()
    }
}

extension SelectProfileVC: SelectProfileViewModelDelegate {
    func handleOutput(_ output: SelectProfileViewModelOutput) {
        switch output {
        case .error(let error):
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        case .fetchUsers(let users):
            self.profiles = users
            print(profiles.map({$0.username}))
            collectionView.reloadData()
        }
    }
    
    
}
