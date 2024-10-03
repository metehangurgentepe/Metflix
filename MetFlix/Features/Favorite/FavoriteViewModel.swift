//
//  FavoriteViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation

class FavoriteViewModel: FavoriteViewModelProtocol {
    var delegate: FavoriteViewModelDelegate?
    
    var movies: [Movie] = []
    
    func load() {
        PersistenceManager.retrieveFavorites {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorites):
                self.movies = favorites
                self.delegate?.handleOutput(.favoriteList(movies))
            case .failure(let error):
                self.delegate?.handleOutput(.error(error))
            }
        }
    }
    
    func filter(_ genreName: String) {
        var filteredMovies: [Movie] = []
        
        movies.forEach { movie in
            if let genresArr = movie.genres {
                if genresArr.contains(where: { $0.name == genreName }) {
                    filteredMovies.append(movie)
                }
            }
        }
    }
    
    func selectMovie(id:Int) {
        self.delegate?.handleOutput(.selectMovie(id))
    }
}
