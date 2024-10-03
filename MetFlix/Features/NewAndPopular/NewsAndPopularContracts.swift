//
//  NewsAndPopularContracts.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 2.10.2024.
//

import Foundation


protocol NewsAndPopularViewModelProtocol {
    var delegate: NewsAndPopularViewModelDelegate? { get set }
    func load() async 
}

enum NewsAndPopularViewModelOutput {
    case getMoviesBySearch([Movie])
    case upcomingMovies([Movie])
    case popularMovies([Movie])
    case topRatedMovies([Movie])
    case popularSeries([Series])
    case setLoading(Bool)
    case selectMovie(Int)
    case error(MovieError)
}

protocol NewsAndPopularViewModelDelegate: AnyObject {
    func handleOutput(_ output: NewsAndPopularViewModelOutput)
}
