//
//  HomeViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation

class HomeViewModel: @preconcurrency HomeViewModelProtocol {
    weak var delegate: MovieListViewModelDelegate?
    
    private var popularMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    private var topRatedMovies: [Movie] = []
    private var nowPlayingMovies: [Movie] = []
    
    @MainActor
    func load() {
        delegate?.handleOutput(.setLoading(true))
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                async let popularTask = self.fetchMovies(from: .popular)
                async let upcomingTask = self.fetchMovies(from: .upcoming)
                async let topRatedTask = self.fetchMovies(from: .topRated)
                async let nowPlayingTask = self.fetchMovies(from: .nowPlaying)
                
                let (popular, upcoming, topRated, nowPlaying) = try await (popularTask, upcomingTask, topRatedTask, nowPlayingTask)
                
                self.popularMovies = popular.results
                self.upcomingMovies = upcoming.results
                self.topRatedMovies = topRated.results
                self.nowPlayingMovies = nowPlaying.results
                
                self.delegate?.handleOutput(.setLoading(false))
            } catch {
                self.delegate?.handleOutput(.error(.apiError))
            }
        }
    }
    
    func selectMovie(id: Int) {
        delegate?.handleOutput(.selectMovie(id))
    }
    
    func tappedSeeAll(endpoint: MovieListEndpoint) {
        delegate?.handleOutput(.tappedSeeAll(endpoint))
    }
    
    func movies(for section: HomeViewController.Section?) -> [Movie] {
        guard let section = section else { return [] }
        switch section {
        case .nowPlaying: return nowPlayingMovies
        case .popular: return popularMovies
        case .upcoming: return upcomingMovies
        case .topRated: return topRatedMovies
        }
    }
    
    private func fetchMovies(from endpoint: MovieListEndpoint) async throws -> MovieResponse {
        do {
            return try await MovieStore.shared.fetchMovies(from: endpoint)
        } catch {
            throw MovieError.serializationError
        }
    }
}
