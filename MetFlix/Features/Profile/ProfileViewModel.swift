//
//  ProfileViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//

import Foundation

class ProfileViewModel: ProfileViewModelProtocol {
    
    weak var delegate: ProfileViewModelDelegate?
    
    @MainActor
    func load() async{
        delegate?.handleOutput(.setLoading(true))
        
        do {
            let popularList = try await MovieStore.shared.fetchMovies(from: .popular)
            self.delegate?.handleOutput(.likedMovies(popularList))
            
            let upcomingList = try await MovieStore.shared.fetchMovies(from: .upcoming)
            self.delegate?.handleOutput(.myList(upcomingList))
            
            self.delegate?.handleOutput(.setLoading(false))
        } catch {
            self.delegate?.handleOutput(.error(error as! MovieError))
            self.delegate?.handleOutput(.setLoading(false))
        }
    }
    
    
    func selectMovie(id: Int) {
        delegate?.handleOutput(.selectMovie(id))
    }
    
    
    func tappedSeeAll(endpoint: MovieListEndpoint) {
//        delegate?.handleOutput(.tappedSeeAll(endpoint))
    }
}
