//
//  MovieDetailViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 26.01.2024.
//

import Foundation
import UIKit


final class MovieDetailViewModel: MovieDetailViewModelProtocol{
    var delegate: MovieDetailViewModelDelegate?
    var id: Int
    var movie: Movie?
    
    init(id: Int) {
        self.id = id
    }
    
    func load() {
        self.delegate?.handleOutput(.setLoading(true))
        Task{
            self.movie = try await MovieStore.shared.fetchMovieDetail(id: id)
            self.delegate?.handleOutput(.getDetail(self.movie!))
            downloadImage()
        }
        self.delegate?.handleOutput(.setLoading(false))
    }
    
    func getSimilarMovies() {
        Task{
            let movies = try await MovieStore.shared.getSimilarMovies(id: id).results
            self.delegate?.handleOutput(.getSimilarMovie(movies))
        }
    }
    
    func fetchMovieVideo() {
        Task{
            let video = try await MovieStore.shared.fetchMovieVideo(id: id).results
            let videoURLKey = video[0].key
            if let url = URL(string:"https://youtube.com/watch?v=\(videoURLKey)") {
                self.delegate?.handleOutput(.didTapPlayButton(url))
            }
        }
    }
    
    @objc func addFavMovie() {
        PersistenceManager.updateWith(favorite: movie!, actionType: .add) { [weak self] (error: MetflixError?) in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.handleOutput(.error(error))
            } else {
                self.delegate?.handleOutput(.addFavMovie)
            }
        }
    }
    
    @objc func removeFavMovie() {
        PersistenceManager.updateWith(favorite: movie!, actionType: .remove) { [weak self] (error: MetflixError?) in
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
                        let image = UIImage(named: "heart.fill")
                        let action = #selector(removeFavMovie)
                        self.delegate?.handleOutput(.configureFavButton(image!, action))
                    } else {
                        let image = UIImage(named: "heart")
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
            NetworkManager.shared.downloadImage(from:(movie.backdropURL)) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async{
                    if let image = image{
                        self.delegate?.handleOutput(.downloadImage(image))
                    }
                }
            }
        }
    }
}
