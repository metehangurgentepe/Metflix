//
//  NewsAndPopularViewModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 2.10.2024.
//

import Foundation

class NewsAndPopularViewModel: NewsAndPopularViewModelProtocol{
    
    weak var delegate: NewsAndPopularViewModelDelegate?
    
    func load() async {
        do{
            let upcomingMovies = try await MovieStore.shared.fetchMovies(from: .upcoming).results
            let popularMovies = try await MovieStore.shared.fetchMovies(from: .popular).results
            let topRatedMovies = try await MovieStore.shared.fetchMovies(from: .topRated).results
            let popularSeries = try await MovieStore.shared.fetchSeries(from: .popular).results
            
            self.delegate?.handleOutput(.upcomingMovies(upcomingMovies))
            self.delegate?.handleOutput(.popularMovies(popularMovies))
            self.delegate?.handleOutput(.topRatedMovies(Array(topRatedMovies.prefix(11))))
            self.delegate?.handleOutput(.popularSeries(Array(popularSeries.prefix(11))))
            
        } catch {
            self.delegate?.handleOutput(.error(error as! MovieError))
        }
    }
}
