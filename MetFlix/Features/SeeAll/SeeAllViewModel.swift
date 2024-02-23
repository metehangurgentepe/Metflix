//
//  SeeAllViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 21.02.2024.
//

import Foundation

class SeeAllViewModel: SeeAllViewModelProtocol {
    var delegate: SeeAllViewModelDelegate?
    
    var endpoint: MovieListEndpoint?
    var page: Int = 1
    var movies: [Movie] =  []
    var id: Int?
    
    init(endpoint: MovieListEndpoint, page: Int, id: Int? = nil) {
        self.endpoint = endpoint
        self.page = page
        self.id = id
    }
    
    
    func load() {
        self.delegate?.handleOutput(.setLoading(true))
        Task { [weak self] in
            guard let self = self else { return }

            let newMovies = try await MovieStore.shared.fetchMoviesList(from: endpoint ?? .nowPlaying, page: page, id: id).results
            self.movies.append(contentsOf: newMovies)

            self.delegate?.handleOutput(.movieList(self.movies))
            self.delegate?.handleOutput(.setLoading(false))
        }
    }
    
    func selectMovie(id: Int) {
        self.delegate?.handleOutput(.selectMovie(id))
    }

}
