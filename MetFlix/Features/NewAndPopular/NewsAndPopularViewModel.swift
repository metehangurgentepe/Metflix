//
//  NewsAndPopularViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 2.10.2024.
//

import Foundation

class NewsAndPopularViewModel: NewsAndPopularViewModelProtocol {
    weak var delegate: NewsAndPopularViewModelDelegate?
    private let movieStore: MovieService
    
    init(movieStore: MovieService = MovieStore.shared) {
        self.movieStore = movieStore
    }
    
    func load() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchUpcomingMovies() }
            group.addTask { await self.fetchPopularMovies() }
            group.addTask { await self.fetchTopRatedMovies() }
            group.addTask { await self.fetchPopularSeries() }
        }
    }
    
    private func fetchUpcomingMovies() async {
        await fetchAndHandle(endpoint: .upcoming) { movies in
                .upcomingMovies(movies)
        }
    }
    
    private func fetchPopularMovies() async {
        await fetchAndHandle(endpoint: .popular) { movies in
                .popularMovies(movies)
        }
    }
    
    private func fetchTopRatedMovies() async {
        await fetchAndHandle(endpoint: .topRated, limit: 11) { movies in
                .topRatedMovies(movies)
        }
    }
    
    private func fetchPopularSeries() async {
        do {
            let series = try await movieStore.fetchSeries(from: .popular).results
            let limitedSeries = Array(series.prefix(11))
            await MainActor.run {
                self.delegate?.handleOutput(.popularSeries(limitedSeries))
            }
        } catch {
            await handleError(error)
        }
    }
    
    private func fetchAndHandle(endpoint: MovieListEndpoint, limit: Int? = nil, outputTransform: @escaping ([Movie]) -> NewsAndPopularViewModelOutput) async {
        do {
            var movies = try await movieStore.fetchMovies(from: endpoint).results
            if let limit = limit {
                movies = Array(movies.prefix(limit))
            }
            await MainActor.run {
                self.delegate?.handleOutput(outputTransform(movies))
            }
        } catch {
            await handleError(error)
        }
    }
    
    private func handleError(_ error: Error) async {
        await MainActor.run {
            let movieError = (error as? MovieError) ?? .apiError
            self.delegate?.handleOutput(.error(movieError))
        }
    }
}
