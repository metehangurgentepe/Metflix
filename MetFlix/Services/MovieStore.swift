//
//  MovieStore.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 27.01.2024.
//

import Foundation

import Foundation

class MovieStore: MovieService {
    static let shared = MovieStore()
    
    private let apiKey: String
    private let baseAPIURL: String
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(apiKey: String = "1771d0ed4cb42b83b8b94fbe2102e24c",
         baseAPIURL: String = "https://api.themoviedb.org/3",
         urlSession: URLSession = .shared,
         jsonDecoder: JSONDecoder = Utils.jsonDecoder) {
        self.apiKey = apiKey
        self.baseAPIURL = baseAPIURL
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchMovies(from endpoint: MovieListEndpoint) async throws -> MovieResponse {
        try await fetchResource(endpoint: "movie/\(endpoint.rawValue)", queryItems: ["language": "en-US"])
    }
    
    func fetchSeries(from endpoint: MovieListEndpoint) async throws -> SeriesResponse {
        try await fetchResource(endpoint: "tv/\(endpoint.rawValue)")
    }
    
    func fetchRecommendedMovies(from endpoint: MovieListEndpoint, id: Int) async throws -> MovieResponse {
        try await fetchResource(endpoint: "movie/\(id)/\(endpoint.rawValue)")
    }
    
    func fetchMoviesList(from endpoint: MovieListEndpoint, page: Int, id: Int?) async throws -> MovieResponse {
        let endpointString = id != nil ? "movie/\(id!)/\(endpoint.rawValue)" : "movie/\(endpoint.rawValue)"
        return try await fetchResource(endpoint: endpointString, queryItems: ["language": "en-US", "page": "\(page)"])
    }
    
    func fetchMovieDetail(id: Int) async throws -> Movie {
        try await fetchResource(endpoint: "movie/\(id)")
    }
    
    func fetchMovieCredits(id: Int) async throws -> MovieCredit {
        try await fetchResource(endpoint: "movie/\(id)/credits")
    }
    
    func searchMovie(query: String) async throws -> MovieResponse {
        try await fetchResource(
            endpoint: "search/movie",
            queryItems: [
                "language": "en-US",
                "include_adult": "false",
                "region": "US",
                "query": query
            ]
        )
    }
    
    func getSimilarMovies(id: Int) async throws -> MovieResponse {
        try await fetchResource(endpoint: "movie/\(id)/similar", queryItems: ["language": "en-US", "page": "1"])
    }
    
    func fetchMovieVideo(id: Int) async throws -> MovieVideoModel {
        try await fetchResource(endpoint: "movie/\(id)/videos", queryItems: ["language": "en-US"])
    }
    
    private func fetchResource<T: Decodable>(endpoint: String, queryItems: [String: String] = [:]) async throws -> T {
        var components = URLComponents(string: "\(baseAPIURL)/\(endpoint)")
        components?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        components?.queryItems?.append(contentsOf: queryItems.map { URLQueryItem(name: $0.key, value: $0.value) })
        
        guard let url = components?.url else {
            throw MovieError.invalidEndpoint
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw MovieError.invalidResponse
        }
        
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw MovieError.serializationError
        }
    }
}
