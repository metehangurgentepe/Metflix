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
            do{
                let movies = try await MovieStore.shared.fetchMovies(from: .popular).results
                self.delegate?.handleOutput(.loadMovies(movies))
            } catch {
                self.delegate?.handleOutput(.error(error as! MovieError))
            }
        }
    }
    
    func search(filter: String) {
        Task{
            do{
                let filteredMovies = try await MovieStore.shared.searchMovie(query: filter).results
                self.delegate?.handleOutput(.getMoviesBySearch(filteredMovies))
            } catch {
                self.delegate?.handleOutput(.error(error as! MovieError))
            }
        }
    }
}
