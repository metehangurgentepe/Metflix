//
//  ProfileVC.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//

import UIKit

class ProfileVC: DataLoadingVC, HomeVCCarouselDelegate {
    let tableView = UITableView(frame: .zero, style: .grouped)
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Netflix"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    lazy var headerView: UIView = {
        let view = UIStackView()
        
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        
        let text = NSAttributedString(string: "Metehan ", attributes: [
            .font: UIFont.systemFont(ofSize: 20, weight: .heavy),
            .foregroundColor: UIColor.white
        ])
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "chevron.down")?.withTintColor(.white)
        attachment.bounds = CGRect(x: 0, y: 3, width: 10, height: 6)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        
        let completeString = NSMutableAttributedString()
        completeString.append(text)
        completeString.append(attachmentString)
        
        label.attributedText = completeString
        
        let image = UIImageView()
        image.image = self.navigationController?.tabBarController?.tabBar.items?[2].image
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        
        image.snp.makeConstraints { make in
            make.height.width.equalTo(60)
        }
        
        view.addArrangedSubview(image)
        view.addArrangedSubview(label)
        
        view.axis = .vertical
        view.spacing = 1
        view.alignment = .center
        view.distribution = .fillEqually
        
        return view
    }()
    
    lazy var titleStackView: UIStackView = {
        let image = UIImageView()
        image.image = self.navigationController?.tabBarController?.tabBar.items?[2].image
        image.layer.cornerRadius = 4
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        
        image.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
        let label = UILabel()
        label.text = "Metehan"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let icon = UIImageView(image: UIImage(systemName: "chevron.down"))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(15)
        }
        
        let stackView = UIStackView(arrangedSubviews: [image, label, icon])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    lazy var viewModel = ProfileViewModel()
    var likedMovies = [Movie]()
    var myList = [Movie]()
    
    let buttonsCell: [ProfileCellModel] = [
        ProfileCellModel(color: .netflixRed, title: "Notifications", icon: UIImage(systemName:"bell.fill")!),
        ProfileCellModel(color: .customBlue, title: "Downloads", icon: UIImage(systemName:"arrow.down.to.line")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavBar()
        headerTableView()
        configureTableView()
        
        viewModel.delegate = self
        
        Task{
            await viewModel.loadData()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        Task{
            await viewModel.loadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        Task{
//            await viewModel.loadData()
//        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        if offset > 15 {
            titleStackView.alpha = offset * 0.01
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleStackView)
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        }
    }
    
    private func configureNavBar() {
        let leftItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = leftItem
        
        let shareItem = UIButton()
        shareItem.setImage(UIImage(systemName: "shareplay")?.resized(to: .init(width: 35, height: 35)).withRenderingMode(.alwaysTemplate), for: .normal)
        shareItem.tintColor = .white
        
        let searchItem = UIButton()
        searchItem.setImage(UIImage(systemName: "magnifyingglass")?.resized(to: .init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), for: .normal)
        searchItem.tintColor = .white
        
        let settingsItem = UIButton()
        settingsItem.setImage(UIImage(systemName: "line.3.horizontal")?.resized(to: .init(width: 35, height: 35)).withRenderingMode(.alwaysTemplate), for: .normal)
        settingsItem.tintColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [shareItem,searchItem,settingsItem])
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
    }
    
    private func configureTableView() {
        tableView.register(ProfileButtonTableViewCell.self, forCellReuseIdentifier: ProfileButtonTableViewCell.identifier)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func headerTableView() {
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenSize.width * 0.9, height: 100)
        tableView.tableHeaderView = headerView
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 240
        case 2:
            return 230
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 1
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileButtonTableViewCell.identifier, for: indexPath) as! ProfileButtonTableViewCell
            let model = buttonsCell[indexPath.row]
            cell.configure(color: model.color, image: model.icon, title: model.title)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as! CollectionViewTableViewCell
            cell.configure(movies: likedMovies, delegate: self)
            cell.isRecommended = true
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as! CollectionViewTableViewCell
            cell.configure(movies: myList, delegate: self)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func didSelectMovie(movieId: Int) {
        viewModel.selectMovie(id: movieId)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let view = Header(title: "Liked Series and Movies", action: nil)
            return view
            
        case 2:
            let view = Header(title: "My List", action: nil)
            return view
            
        default:
            return UIView()
        }
    }
}


extension ProfileVC: ProfileViewModelDelegate {
    func handleOutput(_ output: ProfileViewModelOutput) {
        DispatchQueue.main.async{ [weak self] in
            guard let self else { return }
            switch output {
            case .likedMovies(let movieResponse):
                self.likedMovies = movieResponse
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                
            case .myList(let movieResponse):
                self.myList = movieResponse
                self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
                
            case .error(let movieError):
                self.presentAlertOnMainThread(title: "Error", message: movieError.localizedDescription, buttonTitle: "Ok")
                
            case .setLoading(let bool):
                switch bool {
                case true:
                    self.showLoadingView()
                    
                case false:
                    self.dismissLoadingView()
                }
                
            case .selectMovie(let id):
                let destVC = MovieDetailVC(id: id)
                destVC.modalPresentationStyle = .automatic
                destVC.scrollView.backgroundColor = .black
                
                self.present(destVC, animated: true)
            }
        }
    }
}

