//
//  ProfileViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//

import Foundation

class ProfileViewModel: ProfileViewModelProtocol {
    weak var delegate: ProfileViewModelDelegate?
    private let currentUserId: String
    private let movieStore: MovieService
    private let coreDataManager: CoreDataManagerProtocol
    
    init(currentUserId: String = UserSession.shared.userId ?? "",
         movieStore: MovieService = MovieStore.shared,
         coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.currentUserId = currentUserId
        self.movieStore = movieStore
        self.coreDataManager = coreDataManager
    }
    
    @MainActor
    func loadData() async {
        delegate?.handleOutput(.setLoading(true))
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadLikedMovies() }
            group.addTask { await self.loadMyList() }
        }
        
        delegate?.handleOutput(.setLoading(false))
    }

    @MainActor
    private func loadLikedMovies() async {
        let likedMovies = coreDataManager.fetchLikedMovies(userId: currentUserId)
        let movies = await fetchMovies(from: likedMovies.map { Int($0.movieId) })
        delegate?.handleOutput(.likedMovies(movies))
    }

    @MainActor
    private func loadMyList() async {
        let myList = coreDataManager.fetchMyList(userId: currentUserId)
        let movies = await fetchMovies(from: myList.map { Int($0.movieId) })
        delegate?.handleOutput(.myList(movies))
    }
    
    private func fetchMovies(from movieIds: [Int]) async -> [Movie] {
        var movies: [Movie] = []
        
        for id in movieIds {
            do {
                let movieDetail = try await movieStore.fetchMovieDetail(id: id)
                movies.append(movieDetail)
            } catch {
                handleError(error)
            }
        }
        
        return movies
    }
    
    func selectMovie(id: Int) {
        delegate?.handleOutput(.selectMovie(id))
    }
    
    private func handleError(_ error: Error) {
        let movieError = (error as? MovieError) ?? .apiError
        delegate?.handleOutput(.error(movieError))
    }
}
