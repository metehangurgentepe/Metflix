//
//  MovieService.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 27.01.2024.
//

import Foundation


protocol MovieService {
    func fetchMovies(from endpoint: MovieListEndpoint) async throws -> MovieResponse
    func fetchSeries(from endpoint: MovieListEndpoint) async throws -> SeriesResponse
    func fetchRecommendedMovies(from endpoint: MovieListEndpoint, id: Int) async throws -> MovieResponse
    func fetchMoviesList(from endpoint: MovieListEndpoint, page: Int, id: Int?) async throws -> MovieResponse
    func fetchMovieDetail(id: Int) async throws -> Movie
    func fetchMovieCredits(id: Int) async throws -> MovieCredit
    func searchMovie(query: String) async throws -> MovieResponse
    func getSimilarMovies(id: Int) async throws -> MovieResponse
    func fetchMovieVideo(id: Int) async throws -> MovieVideoModel
}

enum MovieListEndpoint: String, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
    case similar
    case popularSeries
    case recommended = "recommendations"
    
    var description: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .topRated: return "Top Rated"
        case .popular: return "Popular"
        case .similar: return "Similar Movies"
        case .popularSeries: return "Popular Series"
        case .recommended:
            return "Recommended Movies"
        }
    }
}
