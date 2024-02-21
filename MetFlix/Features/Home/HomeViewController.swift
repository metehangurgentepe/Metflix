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
    enum Section {
        case nowPlaying
        case popular
        case upcoming
        case topRated
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    let contentView = UIView()
    
    var tableView = UITableView()
    
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
        collectionSetup()
        setupLayout()
        view.backgroundColor = .systemBackground
        viewModel.delegate = self
        viewModel.load()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func setupHeaderView() {
        let frame: CGRect = CGRect(x: 0, y: 0, width: screenWidth, height: 340)
        let headerView = CarouselView(frame: frame)
        headerView.movies = popularMovies
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        
        headerView.highlightSelectedItem()
    }
    
    
    
    private func collectionSetup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func configureTableView() {
        tableView.separatorStyle = .none
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }
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
        4
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as! CollectionViewTableViewCell
        switch indexPath.section {
        case 0:
            if let movies = nowPlayingMovies?.results {
                cell.configure(movies: movies, delegate: self)
            }
        case 1:
            if let movies = popularMovies?.results {
                cell.configure(movies: movies, delegate: self)
            }
        case 2:
            if let movies = topRatedMovies?.results {
                cell.configure(movies: movies, delegate: self)
            }
        case 3:
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
        case 0:
            return Header(title: "Now Playing", action: UIAction(handler: {[weak self] action in
                guard let self = self else { return }
                self.goToSeeAllScreen(endpoint: .nowPlaying, type: "Now Playing")
            }))
        case 1:
            return Header(title: "Popular", action: UIAction(handler: {[weak self] action in
                guard let self = self else { return }
                self.goToSeeAllScreen(endpoint: .popular, type: "Popular")
            }))
        case 2:
            return Header(title: "Top Rated", action: UIAction(handler: {[weak self] action in
                guard let self = self else { return }
                self.goToSeeAllScreen(endpoint: .topRated, type: "Top Rated")
            }))
        case 3:
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
        switch output {
        case .popular(let popular):
            DispatchQueue.main.async{ [weak self] in
                guard let self = self else { return }
                self.popularMovies = popular
                tableView.reloadData()
                setupHeaderView()
            }
        case .upcoming(let upcoming):
            DispatchQueue.main.async{ [weak self] in
                guard let self = self else { return }
                self.upcomingMovies = upcoming
                tableView.reloadData()
            }
        case .topRated(let topRated):
            DispatchQueue.main.async{ [weak self] in
                guard let self = self else { return }
                self.topRatedMovies = topRated
                tableView.reloadData()
            }
        case .nowPlaying(let nowPlayingList):
            DispatchQueue.main.async{ [weak self] in
                guard let self = self else { return }
                self.nowPlayingMovies = nowPlayingList
                tableView.reloadData()
            }
        case .error(let error):
            presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
        case .setLoading(let bool):
            switch bool {
            case true:
                showLoadingView()
            case false:
                dismissLoadingView()
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
