//
//  SeeAllVC.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 13.02.2024.
//

import UIKit

class SeeAllVC: DataLoadingVC {
    
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var movies: [Movie] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    var movieEndpoint: MovieListEndpoint!
    var movieType: String!
    var page: Int = 1
    var viewModel: SeeAllViewModel?
    var id: Int?
    
    init(endpoint: MovieListEndpoint, type: String, id: Int? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.movieEndpoint = endpoint
        self.movieType = type
        self.id = id
        self.viewModel = SeeAllViewModel(endpoint: endpoint, page: page,id: id)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        viewModel?.delegate = self
        viewModel?.load()
        configureDataSource()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = movieType
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumntFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(SeeAllCell.self, forCellWithReuseIdentifier: SeeAllCell.identifier)
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, movie in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeeAllCell.identifier, for: indexPath) as! SeeAllCell
            cell.set(movie: movie)
            return cell
        })
    }
    
    
    func updatedData(on movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        DispatchQueue.main.async{ [weak self] in
            guard let self = self else { return }
            self.dataSource.apply(snapshot,animatingDifferences: true)
        }
    }
}


extension SeeAllVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = movies[indexPath.item].id
        viewModel?.selectMovie(id: movieId)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            handleScrollEnd(scrollView)
        }
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollEnd(scrollView)
    }
    

    func handleScrollEnd(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            viewModel?.page += 1
            viewModel?.load()
            updatedData(on: viewModel?.movies ?? [])
        }
    }
}


extension SeeAllVC: SeeAllViewModelDelegate {
    func handleOutput(_ output: SeeAllViewModelOutput) {
        switch output {
        case .movieList(let movies):
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.movies = movies
                self.updatedData(on: movies)
            }
            
        case .error(let error):
            presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            
        case .selectMovie(let id):
            let destVC = MovieDetailVC(id: id)
            navigationController?.pushViewController(destVC, animated: true)
            
        case .setLoading(let bool):
            switch bool {
            case true:
                showLoadingView()
            case false:
                dismissLoadingView()
            }
        }
    }
    
    
}
