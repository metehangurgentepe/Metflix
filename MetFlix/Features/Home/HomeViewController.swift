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

class HomeViewController: DataLoadingVC, HomeVCCarouselDelegate {
    let categories = ["TV Shows", "Movies", "Categories"]
    
    enum Section: Int, CaseIterable {
        case nowPlaying = 0
        case popular = 1
        case upcoming = 2
        case topRated = 3
        
        static var numberOfSections: Int {
            return Section.allCases.count
        }
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    let contentView = UIView()
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    
    var nowPlayingMovies: MovieResponse?
    var popularMovies: MovieResponse?
    var upcomingMovies: MovieResponse?
    var topRatedMovies: MovieResponse?
    
    let header = Header(reuseIdentifier: "CollectionTableViewCell")
    
    let padding: Int = -15
    let anotherPadding: Int = 10
    
    weak var delegate: HomeVCCarouselDelegate?
    lazy var viewModel = HomeViewModel()
    var isCollectionViewVisible = true
    let titleView = HomeTitleView(frame: .zero)
    private var titleViewHeightConstraint: Constraint?

    
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        return visualEffectView
    }()
    
    
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
        
        if offsetY < -60 {
            visualEffectView.isHidden = true
        } else {
            visualEffectView.isHidden = false
        }
        
        let titleViewHeight: CGFloat = 80 + UIApplication.shared.statusBarFrame.height
        
        if offsetY > titleViewHeight && isCollectionViewVisible {
            titleView.hideCollectionView()
            isCollectionViewVisible = false
            
            titleView.snp.updateConstraints { make in
                make.height.equalTo(titleViewHeight - 40)
            }
        
        } else if offsetY < titleViewHeight && !isCollectionViewVisible {
            titleView.showCollectionView()
            isCollectionViewVisible = true
            titleView.snp.updateConstraints { make in
                make.height.equalTo(titleViewHeight)
            }
        }
    }
    
    func configureTableView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        view.addSubview(tableView)
        
        tableView.contentInset = UIEdgeInsets(top: 30 + statusBarHeight, left: 0, bottom: 0, right: 0)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func configureNavBar() {
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
                destVC.modalPresentationStyle = .formSheet
                present(destVC, animated: true)
                
            case .tappedSeeAll(let endpoint):
                let destVC = SeeAllVC(endpoint: endpoint, type: endpoint.description)
                navigationController?.pushViewController(destVC, animated: true)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
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
