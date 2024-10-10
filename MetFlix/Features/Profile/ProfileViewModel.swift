//
//  ProfileViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//

import Foundation

class ProfileViewModel: ProfileViewModelProtocol {
    
    weak var delegate: ProfileViewModelDelegate?
    let currentUserId = UserSession.shared.userId
    
    @MainActor
    func loadData() async {
        delegate?.handleOutput(.setLoading(true))
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.loadLikedMovies()
            }
            
            group.addTask {
                await self.loadMyList()
            }
        }
        
        delegate?.handleOutput(.setLoading(false))
    }

    @MainActor
    func loadLikedMovies() async {
        let likedList = CoreDataManager.shared.fetchLikedMovies(userId: currentUserId ?? "")
        var movies: [Movie] = []
        
        for myListItem in likedList {
            do {
                let movieDetail = try await MovieStore.shared.fetchMovieDetail(id: Int(myListItem.movieId))
                movies.append(movieDetail)
            } catch {
                self.delegate?.handleOutput(.error(error as! MovieError))
            }
        }
        
        self.delegate?.handleOutput(.likedMovies(movies))
    }

    @MainActor
    func loadMyList() async {
        let likedList = CoreDataManager.shared.fetchMyList(userId: currentUserId ?? "")
        var movies: [Movie] = []
        
        for myListItem in likedList {
            do {
                let movieDetail = try await MovieStore.shared.fetchMovieDetail(id: Int(myListItem.movieId))
                movies.append(movieDetail)
            } catch {
                self.delegate?.handleOutput(.error(error as! MovieError))
            }
        }
        
        self.delegate?.handleOutput(.myList(movies))
    }
    
    
    func selectMovie(id: Int) {
        delegate?.handleOutput(.selectMovie(id))
    }
    
    
    func tappedSeeAll(endpoint: MovieListEndpoint) {
        //        delegate?.handleOutput(.tappedSeeAll(endpoint))
    }
}
