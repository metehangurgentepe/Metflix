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
    
    
    @objc func addFavMovie() {
        PersistenceManager.updateWith(favorite: movie!, actionType: .add) { [weak self] (error: MovieError?) in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.handleOutput(.error(error))
            } else {
                self.delegate?.handleOutput(.addFavMovie)
            }
        }
    }
    
    
    @objc func removeFavMovie() {
        PersistenceManager.updateWith(favorite: movie!, actionType: .remove) { [weak self] (error: MovieError?) in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.handleOutput(.error(error))
            } else {
                self.delegate?.handleOutput(.removeFavMovie)
            }
        }
    }
    
    
    func checkMovieIsSaved() {
        if let movie = self.movie {
            PersistenceManager.isSaved(favorite: movie) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let isSaved):
                    if isSaved {
                        let image = SFSymbols.selectedFavorites
                        let action = #selector(removeFavMovie)
                        self.delegate?.handleOutput(.configureFavButton(image!, action))
                    } else {
                        let image = SFSymbols.favorites
                        let action = #selector(addFavMovie)
                        self.delegate?.handleOutput(.configureFavButton(image!, action))
                    }
                case .failure(let error):
                    self.delegate?.handleOutput(.error(error))
                }
            }
        }
    }
    
    
    func infoButtonTapped() {
        if let movie = movie {
            if let url = URL(string:movie.homepage ?? "") {
                self.delegate?.handleOutput(.infoButtonTapped(url))
            }
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
}
