//
//  MovieStore.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 27.01.2024.
//

import Foundation



class MovieStore: MovieService {
    
    static let shared = MovieStore()
    
    private init() {}
    
    private let apiKey = "1771d0ed4cb42b83b8b94fbe2102e24c"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    func fetchMovies(from endpoint: MovieListEndpoint) async throws -> MovieResponse {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)?language=en-US") else {
            throw MovieError.invalidEndpoint
        }
        return try await self.loadURLAndDecode(url: url, page: 1)
    }
    
    func fetchSeries(from endpoint: MovieListEndpoint) async throws -> SeriesResponse {
        guard let url = URL(string: "\(baseAPIURL)/tv/\(endpoint.rawValue)") else {
            throw MovieError.invalidEndpoint
        }
        return try await self.loadURLAndDecode(url: url, page: 1)
    }
    
    func fetchRecommendedMovies(from endpoint: MovieListEndpoint, id: Int?) async throws -> MovieResponse {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id!)/\(endpoint.rawValue)") else {
            throw MovieError.invalidEndpoint
        }
        return try await self.loadURLAndDecode(url: url)
    }
    

    func fetchMoviesList(from endpoint: MovieListEndpoint, page: Int, id: Int?) async throws -> MovieResponse {
        if endpoint.rawValue == "similar" && id != nil{
            guard let url = URL(string: "\(baseAPIURL)/movie/\(id!)/\(endpoint.rawValue)?language=en-US") else {
                throw MovieError.invalidEndpoint
            }
            return try await self.loadURLAndDecode(url: url, page: page)
            
        } else {
            guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)?language=en-US") else {
                throw MovieError.invalidEndpoint
            }
            return try await self.loadURLAndDecode(url: url, page: page)
        }
    }
    
    
    func fetchMovieDetail(id: Int) async throws -> Movie {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            throw MovieError.invalidEndpoint
        }
        return try await self.loadURLAndDecode(url: url)
    }
    
    func fetchMovieCredits(id: Int) async throws -> MovieCredit {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)/credits") else {
            throw MovieError.invalidEndpoint
        }
        return try await self.loadURLAndDecode(url: url)
    }
    
    
    func searchMovie(query: String) async throws -> MovieResponse{
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            throw MovieError.invalidEndpoint
        }
        return try await self.loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": query
        ])
    }
    
    
    func getSimilarMovies(id:Int) async throws -> MovieResponse {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)/similar?language=en-US&page=1") else {
            throw MovieError.invalidEndpoint
        }
        return try await self.loadURLAndDecode(url: url)
    }
    
    
    func fetchMovieVideo(id: Int) async throws -> MovieVideoModel {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)/videos?language=en-US") else {
            throw MovieError.invalidEndpoint
        }
        return try await self.loadURLAndDecode(url: url)
    }
    
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, page: Int? = nil) async throws -> D {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw MovieError.invalidEndpoint
        }

        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        if let page = page {
            queryItems.append(URLQueryItem(name: "page", value: String(page)))
        }

        urlComponents.queryItems = queryItems

        guard let finalURL = urlComponents.url else {
            throw MovieError.invalidEndpoint
        }

        let (data, response) = try await URLSession.shared.data(from: finalURL)

        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw MovieError.invalidResponse
        }

        do {
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            return try jsonDecoder.decode(D.self, from: data)
        } catch {
            throw MovieError.serializationError
        }
    }
}
