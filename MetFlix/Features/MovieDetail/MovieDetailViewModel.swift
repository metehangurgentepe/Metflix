//
//  MovieDetailViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation
import UIKit
import SDWebImage


final class MovieDetailViewModel: MovieDetailViewModelProtocol{
    var delegate: MovieDetailViewModelDelegate?
    var id: Int
    var movie: Movie?
    
    
    init(id: Int) {
        self.id = id
    }
    
    func load() async{
        self.delegate?.handleOutput(.setLoading(true))
        do{
            self.movie = try await MovieStore.shared.fetchMovieDetail(id: id)
            self.movie?.credits = try await MovieStore.shared.fetchMovieCredits(id: id)
            self.delegate?.handleOutput(.getDetail(self.movie!))
            downloadImage()
        } catch {
            self.delegate?.handleOutput(.error(error as! MovieError))
        }
        self.delegate?.handleOutput(.setLoading(false))
    }
    
    func getRecommendedMovies() async{
        do{
            let movies = try await MovieStore.shared.fetchRecommendedMovies(from: .recommended, id: id).results
            self.delegate?.handleOutput(.getRecommendedMovies(movies))
        } catch {
            self.delegate?.handleOutput(.error(error as! MovieError))
        }
    }
    
    
    func getSimilarMovies() async{
        do{
            let movies = try await MovieStore.shared.getSimilarMovies(id: id).results
            self.delegate?.handleOutput(.getSimilarMovie(movies))
        } catch {
            self.delegate?.handleOutput(.error(error as! MovieError))
        }
    }
    
    
    func fetchMovieVideo() async{
        do{
            let video = try await MovieStore.shared.fetchMovieVideo(id: id).results
            let videoURLKey = video[0].key
            if let url = URL(string:"https://youtube.com/watch?v=\(videoURLKey)") {
                self.delegate?.handleOutput(.didTapPlayButton(url))
            }
        } catch {
            self.delegate?.handleOutput(.error(error as! MovieError))
        }
    }
    
    
    func addFavMovie(userId: String, movieId: Int) {
        CoreDataManager.shared.likeMovie(userId: userId, movieId: movieId)
    }
    
    
    func removeFavMovie(userId: String, movieId: Int) {
        do{
            try CoreDataManager.shared.removeLikedMovie(userId: userId, movieId: movieId)
        } catch {
            self.delegate?.handleOutput(.error(.serializationError))
        }
    }
    
    func checkIsLiked(userId: String, movieId: Int) -> Bool{
        do {
            return try CoreDataManager.shared.isMovieInLike(userId: userId, movieId: movieId)
        } catch {
            self.delegate?.handleOutput(.error(.serializationError))
            return false
        }
    }
    
    func checkIsDisliked(userId: String, movieId: Int) -> Bool{
        do {
            return try CoreDataManager.shared.isMovieInDislike(userId: userId, movieId: movieId)
        } catch {
            self.delegate?.handleOutput(.error(.serializationError))
            return false
        }
    }
    
    
    func downloadImage() {
        if let movie = self.movie {
            SDWebImageManager.shared.loadImage(
                with: movie.backdropURL,
                options: .highPriority,
                progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    if let image = image {
                        self.delegate?.handleOutput(.downloadImage(image))
                    } else {
                        if let error = error{
                            self.delegate?.handleOutput(.error(error as! MovieError))
                        }
                    }
                }
        }
    }
    
    func isInMyList(movieId: Int, userId: String) -> Bool {
        do{
            return try CoreDataManager.shared.isMovieInMyList(userId: userId, movieId: movieId)
        } catch {
            self.delegate?.handleOutput(.error(.serializationError))
            return false
        }
    }
    
    func addList(movieId: Int, userId: String) {
        do{
            if try !CoreDataManager.shared.isMovieInMyList(userId: userId, movieId: movieId) {
                CoreDataManager.shared.addMyList(userId: userId, movieId: movieId)
            } else {
               try CoreDataManager.shared.removeMyList(userId: userId, movieId: movieId)
            }
        } catch {
            self.delegate?.handleOutput(.error(.invalidResponse))
        }
    }
}
