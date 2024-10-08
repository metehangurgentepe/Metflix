//
//  ViewController.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 24.01.2024.
//

import UIKit
import SnapKit


protocol HomeVCCarouselDelegate: AnyObject {
    func didSelectMovie(movieId: Int)
}

class HomeViewController: DataLoadingVC, HomeVCCarouselDelegate, HomeTitleViewDelegate, SelectCategoryDelegate, UIViewControllerTransitioningDelegate, MovieDetailControllerDelegate {
    var isCollectionViewVisible = true
    
    enum Section: Int, CaseIterable {
        case nowPlaying = 0
        case popular = 1
        case upcoming = 2
        case topRated = 3
        
        static var numberOfSections: Int {
            return Section.allCases.count
        }
    }
    let header = Header(reuseIdentifier: "CollectionTableViewCell")
    let contentView = UIView()
    var tableView = UITableView(frame: .zero, style: .grouped)
    let titleView = HomeTitleView(frame: .zero)
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        return visualEffectView
    }()
    
    var nowPlayingMovies: MovieResponse?
    var popularMovies: MovieResponse?
    var upcomingMovies: MovieResponse?
    var topRatedMovies: MovieResponse?
    
    let padding: Int = -15
    let anotherPadding: Int = 10
    private var titleViewHeightConstraint: Constraint?
    private let topContentInset: CGFloat = UIScreen.main.bounds.size.height < 568 ? 30 : 50
    private let collectionViewHeightReduction: CGFloat = UIScreen.main.bounds.size.height < 568 ? 20 : 30
    var previousOffsetY: CGFloat = 0
    
    weak var delegate: HomeVCCarouselDelegate?
    lazy var viewModel = HomeViewModel()
    let transition = PopAnimator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .systemBackground
        
        viewModel.delegate = self
        viewModel.load()
        
        collectionSetup()
        setupLayout()
        configureNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupHeaderView() {
        guard let popularMovies = popularMovies, !popularMovies.results.isEmpty else {
            return
        }
        
        let headerView = HomeTableViewHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width - 20, height: ScreenSize.height * 0.65))
        headerView.configure(movie: popularMovies.results.first!)
        tableView.tableHeaderView = headerView
        
        tableView.layoutIfNeeded()
    }
    
    
    private func collectionSetup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        let deltaY = offsetY - previousOffsetY
        
        if offsetY < -60 {
            visualEffectView.isHidden = true
        } else {
            visualEffectView.isHidden = false
        }
        
        let titleViewHeight: CGFloat = 80 + UIApplication.shared.statusBarFrame.height
        
        if deltaY < 0 && !isCollectionViewVisible {
            titleView.showCollectionView()
            isCollectionViewVisible = true
            titleViewHeightConstraint?.update(offset: titleViewHeight)
        }
        
        if deltaY > 0 && offsetY > titleViewHeight && isCollectionViewVisible {
            titleView.hideCollectionView()
            isCollectionViewVisible = false
            titleViewHeightConstraint?.update(offset: titleViewHeight - collectionViewHeightReduction)
        }
        
        previousOffsetY = offsetY
    }
    
    func configureTableView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        view.addSubview(tableView)
        
        tableView.contentInset = UIEdgeInsets(top: topContentInset + statusBarHeight, left: 0, bottom: 0, right: 0)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func configureNavBar() {
        titleView.delegate = self
        let statusbarheight = UIApplication.shared.statusBarFrame.height
        
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.backgroundView = visualEffectView
        
        view.addSubview(titleView)
        
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            self.titleViewHeightConstraint = make.height.equalTo(80 + statusbarheight).constraint
        }
        
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: titleView.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
        ])
        
        view.bringSubviewToFront(titleView)
    }
    
    
    private func setupLayout() {
        configureTableView()
    }
    
    
    func didSelectMovie(movieId: Int) {
        viewModel.selectMovie(id: movieId)
    }
    
    
    func goToSeeAllScreen(endpoint: MovieListEndpoint, type: String) {
        viewModel.tappedSeeAll(endpoint: endpoint)
    }
    
    func navigateSearch() {
        let vc = SuggestedSearchViewController()
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func navigateSelectCategoryVC() {
        let selectCategoryVC = SelectCategoryVC()
        selectCategoryVC.delegate = self
        
        selectCategoryVC.modalPresentationStyle = .overCurrentContext
        self.tabBarController?.tabBar.isHidden = true
        
        self.present(selectCategoryVC, animated: true, completion: nil)
        setBlurView()
    }
    
    func setBlurView() {
        let blurView = UIVisualEffectView()
        
        blurView.frame = view.frame
        
        blurView.effect = UIBlurEffect(style: .regular)
        
        view.addSubview(blurView)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    func dismissBlurView() {
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func removeBlurView() {
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func animationController(
      forPresented presented: UIViewController,
      presenting: UIViewController, source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
      return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
      return nil
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.numberOfSections
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as! CollectionViewTableViewCell
        switch indexPath.section {
        case Section.nowPlaying.rawValue:
            if let movies = nowPlayingMovies?.results {
                cell.configure(movies: movies, delegate: self)
            }
        case Section.popular.rawValue:
            if let movies = popularMovies?.results {
                cell.configure(movies: movies, delegate: self)
            }
        case Section.topRated.rawValue:
            if let movies = topRatedMovies?.results {
                cell.configure(movies: movies, delegate: self)
                cell.isTopRated = true
            }
        case Section.upcoming.rawValue:
            if let movies = upcomingMovies?.results {
                cell.configure(movies: movies, delegate: self)
            }
        default:
            break
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case Section.nowPlaying.rawValue:
            return Header(title: "Now Playing", action: UIAction(handler: {[weak self] action in
                guard let self = self else { return }
                self.goToSeeAllScreen(endpoint: .nowPlaying, type: "Now Playing")
            }))
        case Section.popular.rawValue:
            return Header(title: "Popular", action: UIAction(handler: {[weak self] action in
                guard let self = self else { return }
                self.goToSeeAllScreen(endpoint: .popular, type: "Popular")
            }))
        case Section.topRated.rawValue:
            return Header(title: "Top Rated", action: UIAction(handler: {[weak self] action in
                guard let self = self else { return }
                self.goToSeeAllScreen(endpoint: .topRated, type: "Top Rated")
            }))
        case Section.upcoming.rawValue:
            return Header(title: "Upcoming", action: UIAction(handler: { [weak self] action in
                guard let self = self else { return }
                self.goToSeeAllScreen(endpoint: .upcoming, type: "Upcoming")
            }))
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

extension HomeViewController: MovieListViewModelDelegate {
    func handleOutput(_ output: MovieListViewModelOutput) {
        DispatchQueue.main.async{ [weak self] in
            guard let self = self else { return }
            switch output {
            case .popular(let popular):
                self.popularMovies = popular
                setupHeaderView()
                
            case .upcoming(let upcoming):
                self.upcomingMovies = upcoming
                
            case .topRated(let topRated):
                self.topRatedMovies = topRated
                
            case .nowPlaying(let nowPlayingList):
                self.nowPlayingMovies = nowPlayingList
                
            case .error(let error):
                presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
                
            case .setLoading(let bool):
                switch bool {
                case true:
                    showLoadingView()
                    
                case false:
                    dismissLoadingView()
                    tableView.reloadData()
                }
                
            case .selectMovie(let id):
                let destVC = MovieDetailVC(id: id)
                destVC.transitioningDelegate = self
                destVC.modalPresentationStyle = .overFullScreen
                destVC.delegate = self
                
                setBlurView()
                self.present(destVC, animated: true)
                
            case .tappedSeeAll(let endpoint):
                let destVC = SeeAllVC(endpoint: endpoint, type: endpoint.description)
                navigationController?.pushViewController(destVC, animated: true)
            }
        }
    }
}
