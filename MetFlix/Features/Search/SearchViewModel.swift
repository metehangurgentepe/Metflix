//
//  SearchViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation


class SearchViewModel: SearchViewModelProtocol{
    var delegate: SearchViewModelDelegate?
    
    func load() async {
        self.delegate?.handleOutput(.setLoading(true))
        do{
            let movies = try await MovieStore.shared.fetchMovies(from: .popular).results
            self.delegate?.handleOutput(.loadMovies(movies))
            self.delegate?.handleOutput(.setLoading(false))
        } catch {
            self.delegate?.handleOutput(.error(error as! MovieError))
            self.delegate?.handleOutput(.setLoading(false))
        }
    }
    
    func search(filter: String) async{
        self.delegate?.handleOutput(.setLoading(true))
        do{
            let filteredMovies = try await MovieStore.shared.searchMovie(query: filter).results
            self.delegate?.handleOutput(.getMoviesBySearch(filteredMovies))
            self.delegate?.handleOutput(.setLoading(false))
        } catch {
            self.delegate?.handleOutput(.error(error as! MovieError))
            self.delegate?.handleOutput(.setLoading(false))
        }
    }
    
}
