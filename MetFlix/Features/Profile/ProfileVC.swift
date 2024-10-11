//
//  ProfileVC.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//
import UIKit
import SnapKit

class ProfileVC: DataLoadingVC {
    
    // MARK: - Properties
    
    private var viewModel: ProfileViewModelProtocol
    private var likedMovies = [Movie]()
    private var myList = [Movie]()
    
    private let buttonsCell: [ProfileCellModel] = [
        ProfileCellModel(color: .netflixRed, title: "Notifications", icon: UIImage(systemName:"bell.fill")!),
        ProfileCellModel(color: .customBlue, title: "Downloads", icon: UIImage(systemName:"arrow.down.to.line")!)
    ]
    
    // MARK: - UI Components
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(ProfileButtonTableViewCell.self, forCellReuseIdentifier: ProfileButtonTableViewCell.identifier)
        tv.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Netflix"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var headerView: UIView = {
        let user = UserProfileManager.shared.selectedProfile
        
        let containerView = UIView()
        
        let image = UIImageView()
        image.image = UIImage(named: user?.imageName ?? "")
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        let text = NSAttributedString(string: user?.username ?? "", attributes: [
            .font: UIFont.systemFont(ofSize: 20, weight: .heavy),
            .foregroundColor: UIColor.white
        ])
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "chevron.down")?.withTintColor(.white)
        attachment.bounds = CGRect(x: 0, y: 3, width: 10, height: 6)
        let attachmentString = NSAttributedString(attachment: attachment)
        let completeString = NSMutableAttributedString(attributedString: text)
        completeString.append(attachmentString)
        label.attributedText = completeString
        
        containerView.addSubview(image)
        containerView.addSubview(label)
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(160)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return containerView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let user = UserProfileManager.shared.selectedProfile
        
        let image = UIImageView()
        image.image = self.navigationController?.tabBarItem.image
        image.layer.cornerRadius = 4
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.snp.makeConstraints { $0.width.height.equalTo(30) }
        
        let label = UILabel()
        label.text = user?.username
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let icon = UIImageView(image: UIImage(systemName: "chevron.down"))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.snp.makeConstraints { $0.width.height.equalTo(15) }
        
        let stackView = UIStackView(arrangedSubviews: [image, label, icon])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    // MARK: - Initialization
    
    init(viewModel: ProfileViewModelProtocol = ProfileViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
        loadData()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        let shareItem = createNavBarButton(systemName: "shareplay", size: 35)
        let searchItem = createNavBarButton(systemName: "magnifyingglass", size: 25)
        searchItem.addTarget(self, action: #selector(searchItemTapped), for: .touchUpInside)
        let settingsItem = createNavBarButton(systemName: "line.3.horizontal", size: 35)
        
        let stackView = UIStackView(arrangedSubviews: [shareItem, searchItem, settingsItem])
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenSize.width * 0.9, height: 200)
        tableView.tableHeaderView = headerView
    }
    
    private func setupBindings() {
        viewModel.delegate = self
    }
    
    private func loadData() {
        Task {
            await viewModel.loadData()
        }
    }
    
    // MARK: - Helper Methods
    
    private func createNavBarButton(systemName: String, size: CGFloat) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: systemName)?.resized(to: .init(width: size, height: size)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }
    
    @objc private func searchItemTapped() {
        let vc = SuggestedSearchViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1, 2: return 1
        default: return 0
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1: return Header(title: "Liked Series and Movies", action: nil)
        case 2: return Header(title: "My List", action: nil)
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1: return 240
        case 2: return 230
        default: return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
}

// MARK: - UIScrollViewDelegate

extension ProfileVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset > 15 {
            titleStackView.alpha = offset * 0.01
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleStackView)
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        }
    }
}

// MARK: - HomeVCCarouselDelegate

extension ProfileVC: HomeVCCarouselDelegate {
    func didSelectMovie(movieId: Int) {
        viewModel.selectMovie(id: movieId)
    }
}

// MARK: - ProfileViewModelDelegate

extension ProfileVC: ProfileViewModelDelegate {
    func handleOutput(_ output: ProfileViewModelOutput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch output {
            case .likedMovies(let movies):
                self.likedMovies = movies
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            case .myList(let movies):
                self.myList = movies
                self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
            case .error(let error):
                self.presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            case .setLoading(let isLoading):
                isLoading ? self.showLoadingView() : self.dismissLoadingView()
            case .selectMovie(let id):
                let destVC = MovieDetailVC(id: id)
                destVC.modalPresentationStyle = .automatic
                destVC.scrollView.backgroundColor = .black
                self.present(destVC, animated: true)
            }
        }
    }
}
