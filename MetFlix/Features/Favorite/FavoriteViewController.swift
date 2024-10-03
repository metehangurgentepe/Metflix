//
//  FavoriteViewController.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation
import UIKit

class FavoriteViewController: UIViewController {
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var movies: [Movie] = []
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!
    var filteredMovies: [Movie] = []
    var viewModel = FavoriteViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.load()
        configureViewController()
        configureCollectionView()
        configureDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favorites"
        
        let filterButton = UIBarButtonItem(image: SFSymbols.filter,
                                           style: .done,
                                           target: self,
                                           action: #selector(filterButtonTapped))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumntFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FavoriteMovieCell.self, forCellWithReuseIdentifier: FavoriteMovieCell.identifier)
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, movie in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteMovieCell.identifier, for: indexPath) as! FavoriteMovieCell
            cell.set(movie: movie)
            return cell
        })
    }
    
    
    func updatedData(on favorites: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(favorites)
        DispatchQueue.main.async{
            self.dataSource.apply(snapshot,animatingDifferences: true)
        }
    }
    
    
    @objc func filterButtonTapped() {
        let alertController = UIAlertController(title: "Filter by Genre", message: "\n\n\n\n\n", preferredStyle: .actionSheet)
        
        
        let label = UILabel()
        label.text = "Filter by Genre"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(22)
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.frame = CGRect(x: 0, y: label.frame.height / 2, width: alertController.view.frame.width, height: 150)
        
        alertController.view.addSubview(label)
        alertController.view.addSubview(pickerView)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let applyAction = UIAlertAction(title: "Apply", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let selectedGenreIndex = pickerView.selectedRow(inComponent: 0)
            if selectedGenreIndex < Genre.allCases.count {
                let selectedGenre = Genre.allCases[selectedGenreIndex]
                self.handleOutput(.filter(selectedGenre))
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(applyAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieId = movies[indexPath.item].id
        viewModel.selectMovie(id: movieId)
    }
}

extension FavoriteViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Genre.allCases.count
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Genre.allCases[row]
    }
}


extension FavoriteViewController: FavoriteViewModelDelegate {
    func handleOutput(_ output: FavoriteViewModelOutput) {
        switch output {
        case .favoriteList(let movies):
            self.movies = movies
            updatedData(on: self.movies)
            
        case .error(let error):
            presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
            
        case .selectMovie(let id):
            let destVC = MovieDetailVC(id: id)
            navigationController?.pushViewController(destVC, animated: true)
            
        case .filter(let genreName):
            var filteredMovies: [Movie] = []
            
            movies.forEach { movie in
                if let genresArr = movie.genres {
                    if genresArr.contains(where: { $0.name == genreName }) {
                        filteredMovies.append(movie)
                    }
                }
            }
            updatedData(on: filteredMovies)
        }
    }
}
