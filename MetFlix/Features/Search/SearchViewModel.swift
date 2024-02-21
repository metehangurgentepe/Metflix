//
//  SearchViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation


class SearchViewModel: SearchViewModelProtocol{
    var delegate: SearchViewModelDelegate?
    
    func load() {
        Task{
            let movies = try await MovieStore.shared.fetchMovies(from: .popular).results
            self.delegate?.handleOutput(.loadMovies(movies))
        }
    }
    
    func search(filter: String) {
        Task{
            let filteredMovies = try await MovieStore.shared.searchMovie(query: filter).results
            self.delegate?.handleOutput(.getMoviesBySearch(filteredMovies))
        }
    }
}
