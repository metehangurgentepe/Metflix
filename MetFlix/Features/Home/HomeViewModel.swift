//
//  HomeViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation


class HomeViewModel: MovielistViewModelProtocol {
    
    weak var delegate: MovieListViewModelDelegate?
    
    @MainActor
    func load() {
        delegate?.handleOutput(.setLoading(true))
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let popularList = try await MovieStore.shared.fetchMovies(from: .popular)
                self.delegate?.handleOutput(.popular(popularList))
                
                let upcomingList = try await MovieStore.shared.fetchMovies(from: .upcoming)
                self.delegate?.handleOutput(.upcoming(upcomingList))
                
                let topRatedList = try await MovieStore.shared.fetchMovies(from: .topRated)
                self.delegate?.handleOutput(.topRated(topRatedList))
                
                let nowPlayingList = try await MovieStore.shared.fetchMovies(from: .nowPlaying)
                self.delegate?.handleOutput(.nowPlaying(nowPlayingList))
                
                self.delegate?.handleOutput(.setLoading(false))
            } catch {
                self.delegate?.handleOutput(.error(error))
                self.delegate?.handleOutput(.setLoading(false))
            }
        }
    }
    
    
    func selectMovie(id: Int) {
        delegate?.handleOutput(.selectMovie(id))
    }
    
    
    func tappedSeeAll(endpoint: MovieListEndpoint) {
        delegate?.handleOutput(.tappedSeeAll(endpoint))
    }
}
