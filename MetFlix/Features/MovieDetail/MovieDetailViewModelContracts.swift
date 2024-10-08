//
//  MovieDetailViewModelContracts.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 22.02.2024.
//

import Foundation
import UIKit

protocol MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate? { get set }
    func load() async
    func getRecommendedMovies() async
    func getSimilarMovies() async
    func fetchMovieVideo() async
}

enum MovieDetailViewModelOutput {
    case getDetail(Movie)
    case setLoading(Bool)
    case error(MovieError)
    case downloadImage(UIImage)
    case getSimilarMovie([Movie])
    case didTapPlayButton(URL)
    case addFavMovie
    case getRecommendedMovies([Movie])
    case removeFavMovie
    case infoButtonTapped(URL)
    case configureFavButton(UIImage, Selector)
}


protocol MovieDetailViewModelDelegate {
    func handleOutput(_ output: MovieDetailViewModelOutput)
}
