//
//  ViewController.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 24.01.2024.
//

import UIKit


protocol HomeVCCarouselDelegate: AnyObject {
    func didSelectMovie(movieId: Int)
}

class HomeViewController: DataLoadingVC, HomeVCCarouselDelegate {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.load()
        configureNavBar()
        collectionSetup()
        setupLayout()
        view.backgroundColor = .systemBackground
//        navigationController?.navigationBar.applyBlurEffect()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    
    func setupHeaderView() {
        let frame: CGRect = CGRect(x: 0, y: 0, width: screenWidth, height: 340)
        let headerView = CarouselView(frame: frame)
        headerView.movies = popularMovies
        headerView.delegate = self
        tableView.tableHeaderView = headerView
    }
    
    
    private func collectionSetup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func configureTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func configureNavBar() {
        
        let title = UILabel()
        title.text = "Metehan için"
        title.textColor = .white
        title.font = .preferredFont(forTextStyle: .headline).withSize(24)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: title)
        
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "shareplay"), style: .plain, target: self, action: nil)
        let downloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line"), style: .plain, target: self, action: nil)
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        shareButton.tintColor = .white
        downloadButton.tintColor = .white
        searchButton.tintColor = .white
        navigationItem.rightBarButtonItems?.forEach({ $0.tintColor = .white})
        
        navigationItem.rightBarButtonItems = [
            searchButton,
            downloadButton,
            shareButton
        ]
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
                navigationController?.pushViewController(destVC, animated: true)
                
            case .tappedSeeAll(let endpoint):
                let destVC = SeeAllVC(endpoint: endpoint, type: endpoint.description)
                navigationController?.pushViewController(destVC, animated: true)
            }
        }
    }
}
