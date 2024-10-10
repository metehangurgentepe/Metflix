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

class HomeViewController: DataLoadingVC {
    // MARK: - Properties
    enum Section: Int, CaseIterable {
        case nowPlaying, popular, upcoming, topRated
        
        static var numberOfSections: Int { allCases.count }
        
        var title: String {
            switch self {
            case .nowPlaying: return "Now Playing"
            case .popular: return "Popular"
            case .upcoming: return "Upcoming"
            case .topRated: return "Top Rated"
            }
        }
        
        var endpoint: MovieListEndpoint {
            switch self {
            case .nowPlaying: return .nowPlaying
            case .popular: return .popular
            case .upcoming: return .upcoming
            case .topRated: return .topRated
            }
        }
    }
    
    private var isCollectionViewVisible = true
    private var viewModel: HomeViewModelProtocol
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let titleView = HomeTitleView(frame: .zero)
    private let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        return UIVisualEffectView(effect: blurEffect)
    }()
    
    private var titleViewHeightConstraint: Constraint?
    private let topContentInset: CGFloat = UIScreen.main.bounds.size.height < 568 ? 30 : 50
    private let collectionViewHeightReduction: CGFloat = UIScreen.main.bounds.size.height < 568 ? 20 : 30
    private var previousOffsetY: CGFloat = 0
    
    // MARK: - Lifecycle
    init(viewModel: HomeViewModelProtocol = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        
        setupHeaderView()
        setupTableView()
        setupTitleView()
        setupVisualEffectView()
    }
    
    private func setupBindings() {
        viewModel.delegate = self
    }
    
    private func setupHeaderView() {
        let popularMovies = viewModel.movies(for: .popular)
        
        guard !popularMovies.isEmpty else {
            return
        }
        
        let headerView = HomeTableViewHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width - 20, height: ScreenSize.height * 0.65))
        
        if let firstMovie = popularMovies.first {
            headerView.configure(movie: firstMovie)
        }
        
        tableView.tableHeaderView = headerView
        tableView.layoutIfNeeded()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = UIEdgeInsets(top: topContentInset + statusBarHeight, left: 0, bottom: 0, right: 0)
    }
    
    private func setupTitleView() {
        titleView.delegate = self
        view.addSubview(titleView)
        
        titleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            self.titleViewHeightConstraint = make.height.equalTo(80 + UIApplication.shared.statusBarFrame.height).constraint
        }
        
        view.bringSubviewToFront(titleView)
    }
    
    private func setupVisualEffectView() {
        titleView.backgroundView = visualEffectView
        visualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        let section = Section(rawValue: indexPath.section)
        cell.configure(movies: viewModel.movies(for: section), delegate: self)
        cell.isTopRated = section == .topRated
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else { return nil }
        return Header(title: section.title, action: UIAction { [weak self] _ in
            //            self?.goToSeeAllScreen(endpoint: section.endpoint, type: section.title)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        220
    }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let deltaY = offsetY - previousOffsetY
        
        visualEffectView.isHidden = offsetY < -60
        
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
}

// MARK: - HomeVCCarouselDelegate
extension HomeViewController: HomeVCCarouselDelegate {
    func didSelectMovie(movieId: Int) {
        viewModel.selectMovie(id: movieId)
    }
}

// MARK: - HomeTitleViewDelegate
extension HomeViewController: HomeTitleViewDelegate {
    func navigateSearch() {
        let vc = SuggestedSearchViewController()
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func navigateSelectCategoryVC() {
        let selectCategoryVC = SelectCategoryVC()
        selectCategoryVC.delegate = self
        selectCategoryVC.modalPresentationStyle = .overCurrentContext
        tabBarController?.tabBar.isHidden = true
        present(selectCategoryVC, animated: true)
        setBlurView()
        titleView.collectionView.deselectItem(at: IndexPath(item: 2, section: 0), animated: false)
    }
}

// MARK: - SelectCategoryDelegate
extension HomeViewController: SelectCategoryDelegate {
    // Implement SelectCategoryDelegate methods
    private func setBlurView() {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.frame = view.frame
        view.addSubview(blurView)
        tabBarController?.tabBar.isHidden = true
    }
    
    internal func removeBlurView() {
        view.subviews.filter { $0 is UIVisualEffectView }.forEach { $0.removeFromSuperview() }
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - MovieListViewModelDelegate
extension HomeViewController: MovieListViewModelDelegate {
    func handleOutput(_ output: MovieListViewModelOutput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch output {
            case .setLoading(let isLoading):
                isLoading ? showLoadingView() : dismissLoadingView()
                if !isLoading {
                    tableView.reloadData()
                    setupHeaderView()
                }
            case .error(let error):
                presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
                
            case .selectMovie(let id):
                let destVC = MovieDetailVC(id: id)
                destVC.transitioningDelegate = self
                destVC.modalPresentationStyle = .overFullScreen
                destVC.delegate = self
                setBlurView()
                present(destVC, animated: true)
                
            case .tappedSeeAll(let endpoint):
                let destVC = SeeAllVC(endpoint: endpoint, type: endpoint.description)
                navigationController?.pushViewController(destVC, animated: true)
                
            default:
                break
            }
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        PopAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil
    }
}

// MARK: - MovieDetailControllerDelegate
extension HomeViewController: MovieDetailControllerDelegate {
    func dismissBlurView() {
        view.subviews.filter { $0 is UIVisualEffectView }.forEach { $0.removeFromSuperview() }
        tabBarController?.tabBar.isHidden = false
    }
}
