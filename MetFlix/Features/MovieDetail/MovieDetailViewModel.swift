//
//  MovieDetailViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//
import Foundation
import UIKit
import SDWebImage

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate?
    private let id: Int
    private var movie: Movie?
    private let movieStore: MovieService
    private let coreDataManager: CoreDataManagerProtocol
    private let imageLoader: ImageLoaderProtocol
    
    init(id: Int,
         movieStore: MovieService = MovieStore.shared,
         coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared,
         imageLoader: ImageLoaderProtocol = SDWebImageLoader()
    ){
        self.id = id
        self.movieStore = movieStore
        self.coreDataManager = coreDataManager
        self.imageLoader = imageLoader
    }
    
    @MainActor
    func load() async {
        delegate?.handleOutput(.setLoading(true))
        do {
            async let movieDetail = movieStore.fetchMovieDetail(id: id)
            async let movieCredits = movieStore.fetchMovieCredits(id: id)
            
            let (detail, credits) = await (try movieDetail, try movieCredits)
            movie = detail
            movie?.credits = credits
            
            if let movie = movie {
                delegate?.handleOutput(.getDetail(movie))
                downloadImage(for: movie)
            }
        } catch {
            handleError(error)
        }
        delegate?.handleOutput(.setLoading(false))
    }
    
    @MainActor
    func getRecommendedMovies() async {
        do {
            let movies = try await movieStore.fetchRecommendedMovies(from: .recommended, id: id).results
            delegate?.handleOutput(.getRecommendedMovies(movies))
        } catch {
            handleError(error)
        }
    }
    
    @MainActor
    func getSimilarMovies() async {
        do {
            let movies = try await movieStore.getSimilarMovies(id: id).results
            delegate?.handleOutput(.getSimilarMovie(movies))
        } catch {
            handleError(error)
        }
    }
    
    @MainActor
    func fetchMovieVideo() async {
        do {
            let videos = try await movieStore.fetchMovieVideo(id: id).results
            if let videoURLKey = videos.first?.key,
               let url = URL(string: "https://youtube.com/watch?v=\(videoURLKey)") {
                delegate?.handleOutput(.didTapPlayButton(url))
            }
        } catch {
            handleError(error)
        }
    }
    
    func addFavMovie(userId: String, movieId: Int) {
        coreDataManager.likeMovie(userId: userId, movieId: movieId)
    }
    
    func removeFavMovie(userId: String, movieId: Int) {
        do {
            try coreDataManager.unlikeMovie(userId: userId, movieId: movieId)
        } catch {
            handleError(error)
        }
    }
    
    func checkIsLiked(userId: String, movieId: Int) -> Bool {
        coreDataManager.isMovieLiked(userId: userId, movieId: movieId)
    }
    
    func checkIsDisliked(userId: String, movieId: Int) -> Bool {
        coreDataManager.isMovieDisliked(userId: userId, movieId: movieId)
    }
    
    func isInMyList(movieId: Int, userId: String) -> Bool {
        coreDataManager.isMovieInMyList(userId: userId, movieId: movieId)
    }
    
    func addList(movieId: Int, userId: String) {
        do {
            if !coreDataManager.isMovieInMyList(userId: userId, movieId: movieId) {
                coreDataManager.addToMyList(userId: userId, movieId: movieId)
            } else {
                try coreDataManager.removeFromMyList(userId: userId, movieId: movieId)
            }
        } catch {
            handleError(error)
        }
    }
    
    private func downloadImage(for movie: Movie) {
        imageLoader.loadImage(with: movie.backdropURL) { [weak self] result in
            switch result {
            case .success(let image):
                self?.delegate?.handleOutput(.downloadImage(image))
            case .failure(let error):
                self?.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: Error) {
        let movieError = (error as? MovieError) ?? .apiError
        delegate?.handleOutput(.error(movieError))
    }
}
