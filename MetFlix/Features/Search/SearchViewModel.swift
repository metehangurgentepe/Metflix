//
//  SearchViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation


class SearchViewModel: SearchViewModelProtocol{
    var delegate: SearchViewModelDelegate?
    
    private let movieStore: MovieService
    
    init(movieStore: MovieService = MovieStore.shared) {
        self.movieStore = movieStore
    }
    
    @MainActor
    func load() async {
        await performTask { [weak self] in
            let movies = try await self?.movieStore.fetchMovies(from: .popular).results ?? []
            self?.delegate?.handleOutput(.loadMovies(movies))
        }
    }
    
    @MainActor
    func search(filter: String) async {
        await performTask { [weak self] in
            let filteredMovies = try await self?.movieStore.searchMovie(query: filter).results ?? []
            self?.delegate?.handleOutput(.getMoviesBySearch(filteredMovies))
        }
    }
    
    private func performTask(_ task: @escaping () async throws -> Void) async {
        delegate?.handleOutput(.setLoading(true))
        do {
            try await task()
        } catch {
            handleError(error)
        }
        delegate?.handleOutput(.setLoading(false))
    }
    
    private func handleError(_ error: Error) {
        let movieError = (error as? MovieError) ?? .apiError
        delegate?.handleOutput(.error(movieError))
    }
}
