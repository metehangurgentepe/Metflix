//
//  SuggestedSearchViewController.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 4.10.2024.
//

import UIKit

class SuggestedSearchViewController: UIViewController, HomeVCCarouselDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    enum Section {
        case main
    }
    
    var suggestedMovies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.tintColor = .white
        sb.placeholder = "Oyun, dizi veya film arayın."
        sb.layer.cornerRadius = 2
        sb.backgroundImage = UIImage()
        return sb
    }()
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    let activity = UIActivityIndicatorView(style: .medium)
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        
        viewModel.delegate = self
        Task{ await viewModel.load() }
        
        view.backgroundColor = .systemBackground
        configureNavBar()
        configureLoading()
        configureTableView()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationController?.viewControllers.count ?? 0 > 1
    }
    
    func updatedData(on movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        DispatchQueue.main.async{
            self.dataSource.apply(snapshot,animatingDifferences: true)
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeeAllCell.identifier, for: indexPath) as! SeeAllCell
            let movie = self.filteredMovies[indexPath.row]
            cell.set(movie: movie)
            return cell
        })
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createThreeColumntFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SeeAllCell.self, forCellWithReuseIdentifier: SeeAllCell.identifier)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    private func configureNavBar() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.tintColor = .white
        searchBar.searchTextField.leftView?.tintColor = .lightGray
        searchBar.placeholder = "Oyun, dizi veya film arayın."
        searchBar.layer.cornerRadius = 2
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Oyun, dizi veya film arayın.",
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: 12, weight: .light)
            ]
        )
        
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        let stackView = UIStackView(arrangedSubviews: [backButton, searchBar])
        stackView.spacing = 4
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: false)
    }
    
    private func configureLoading() {
        activity.color = .white
        activity.hidesWhenStopped = true
        activity.isHidden = true
        
        view.addSubview(activity)
        
        activity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView.register(SuggestedMovieCell.self, forCellReuseIdentifier: SuggestedMovieCell.identifier)
        tableView.register(HorizontalMobileTableViewCell.self, forCellReuseIdentifier: HorizontalMobileTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(6)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            searchBar.resignFirstResponder()
        }
    }
    
    func didSelectMovie(movieId: Int) {
        
    }
}

extension SuggestedSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = filteredMovies[indexPath.row].id
        viewModel.delegate?.handleOutput(.selectMovie(movieId))
    }
}

extension SuggestedSearchViewController: SearchViewModelDelegate {
    func handleOutput(_ output: SearchViewModelOutput) {
        DispatchQueue.main.async {
            switch output {
            case .getMoviesBySearch(let movies):
                self.filteredMovies = movies
                self.updatedData(on: movies)
                
                self.collectionView.isHidden = false
                self.tableView.isHidden = true
                
            case .loadMovies(let array):
                self.suggestedMovies = array
                self.tableView.reloadData()
                
                self.collectionView.isHidden = true
                self.tableView.isHidden = false
                
            case .setLoading(let isLoading):
                if isLoading{
                    self.activity.startAnimating()
                    self.activity.isHidden = false
                    self.tableView.isHidden = true
                } else {
                    self.activity.stopAnimating()
                    self.tableView.isHidden = false
                }
            case .selectMovie(let int):
                break
                
            case .error(let movieError):
                break
                //                presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
}

extension SuggestedSearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = searchBar.text ?? ""
        
        if filter.isEmpty {
            tableView.isHidden = false
            collectionView.isHidden = true
        } else {
            Task{
                await viewModel.search(filter: filter)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let filter = searchController.searchBar.text ?? ""
        if filter.isEmpty {
            Task{
                await viewModel.load()
            }
        } else {
            Task{
                await viewModel.search(filter: filter)
            }
        }
    }
}

extension SuggestedSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160
        case 1:
            return 100
        default:
            return 0
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Önerilen Mobil Oyunlar"
        case 1:
            return "Önerilen Dizi ve Filmler"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return suggestedMovies.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalMobileTableViewCell.identifier) as! HorizontalMobileTableViewCell
            cell.configure(movies: suggestedMovies, delegate: self)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SuggestedMovieCell.identifier, for: indexPath) as! SuggestedMovieCell
            cell.configure(movie: suggestedMovies[indexPath.row])
            return cell
            
        default:
            return UITableViewCell()
        }
        
        
    }
}
