//
//  SuggestedSearchViewController.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 4.10.2024.
//

import UIKit
import SnapKit

class SuggestedSearchViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Enums
    
    private enum Section {
        case main
    }
    
    private enum TableViewSection: Int, CaseIterable {
        case mobileGames = 0
        case moviesAndSeries = 1
        
        var title: String {
            switch self {
            case .mobileGames:
                return "Önerilen Mobil Oyunlar"
            case .moviesAndSeries:
                return "Önerilen Dizi ve Filmler"
            }
        }
    }
    
    // MARK: - Properties
    
    private let viewModel = SearchViewModel()
    private var suggestedMovies: [Movie] = []
    private var filteredMovies: [Movie] = []
    
    // MARK: - UI Components
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.tintColor = .white
        sb.placeholder = "Oyun, dizi veya film arayın."
        sb.layer.cornerRadius = 2
        sb.backgroundImage = UIImage()
        sb.delegate = self
        sb.searchTextField.delegate = self
        sb.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Oyun, dizi veya film arayın.",
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: 12, weight: .light)
            ]
        )
        sb.searchTextField.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return sb
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(SuggestedMovieCell.self, forCellReuseIdentifier: SuggestedMovieCell.identifier)
        tv.register(HorizontalMobileTableViewCell.self, forCellReuseIdentifier: HorizontalMobileTableViewCell.identifier)
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createThreeColumntFlowLayout(in: view))
        cv.delegate = self
        cv.backgroundColor = .systemBackground
        cv.register(SeeAllCell.self, forCellWithReuseIdentifier: SeeAllCell.identifier)
        return cv
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.color = .white
        ai.hidesWhenStopped = true
        return ai
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupNavBar()
        setupTableView()
        setupCollectionView()
        setupActivityIndicator()
    }
    
    private func setupNavBar() {
        let stackView = UIStackView(arrangedSubviews: [backButton, searchBar])
        stackView.spacing = 4
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, movie in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeeAllCell.identifier, for: indexPath) as? SeeAllCell else {
                return UICollectionViewCell()
            }
            cell.set(movie: movie)
            return cell
        }
    }
    
    private func loadData() {
        viewModel.delegate = self
        Task {
            await viewModel.load()
        }
    }
    
    // MARK: - Helper Methods
    
    private func updatedData(on movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension SuggestedSearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}

// MARK: - UICollectionViewDelegate

extension SuggestedSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = filteredMovies[indexPath.row].id
        viewModel.delegate?.handleOutput(.selectMovie(movieId))
    }
}

// MARK: - SearchViewModelDelegate

extension SuggestedSearchViewController: SearchViewModelDelegate {
    func handleOutput(_ output: SearchViewModelOutput) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            switch output {
            case .getMoviesBySearch(let movies):
                self.filteredMovies = movies
                self.updatedData(on: movies)
                self.collectionView.isHidden = false
                self.tableView.isHidden = true
                
            case .loadMovies(let movies):
                self.suggestedMovies = movies
                self.tableView.reloadData()
                self.collectionView.isHidden = true
                self.tableView.isHidden = false
                
            case .setLoading(let isLoading):
                if isLoading {
                    self.activityIndicator.startAnimating()
                    self.tableView.isHidden = true
                } else {
                    self.activityIndicator.stopAnimating()
                    self.tableView.isHidden = false
                }
                
            case .selectMovie(let id):
                let destVC = MovieDetailVC(id: id)
                destVC.modalPresentationStyle = .automatic
                destVC.scrollView.backgroundColor = .black
                present(destVC, animated: true)
                
            case .error:
                break
            }
        }
    }
}

// MARK: - UISearchBarDelegate, UISearchResultsUpdating

extension SuggestedSearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleSearchTextChange(searchText)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let filter = searchController.searchBar.text ?? ""
        handleSearchTextChange(filter)
    }
    
    private func handleSearchTextChange(_ searchText: String) {
        if searchText.isEmpty {
            tableView.isHidden = false
            collectionView.isHidden = true
            Task {
                await viewModel.load()
            }
        } else {
            Task {
                await viewModel.search(filter: searchText)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SuggestedSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = TableViewSection(rawValue: section) else { return 0 }
        switch section {
        case .mobileGames:
            return 1
        case .moviesAndSeries:
            return suggestedMovies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TableViewSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .mobileGames:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalMobileTableViewCell.identifier, for: indexPath) as? HorizontalMobileTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(movies: suggestedMovies, delegate: self)
            return cell
            
        case .moviesAndSeries:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedMovieCell.identifier, for: indexPath) as? SuggestedMovieCell else {
                return UITableViewCell()
            }
            cell.configure(movie: suggestedMovies[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TableViewSection(rawValue: section)?.title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = TableViewSection(rawValue: indexPath.section) else { return 0 }
        switch section {
        case .mobileGames:
            return 160
        case .moviesAndSeries:
            return 100
        }
    }
}

// MARK: - HomeVCCarouselDelegate

extension SuggestedSearchViewController: HomeVCCarouselDelegate {
    func didSelectMovie(movieId: Int) {
        let destVC = MovieDetailVC(id: movieId)
        destVC.modalPresentationStyle = .overFullScreen
        destVC.scrollView.backgroundColor = .black
        present(destVC, animated: true)
    }
}
