//
//  HomeViewModelContracts.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 21.02.2024.
//

import Foundation

protocol MovielistViewModelProtocol {
    var delegate: MovieListViewModelDelegate? { get set }
    func load()
    func selectMovie(id: Int)
    func tappedSeeAll(endpoint: MovieListEndpoint)
}

enum MovieListViewModelOutput {
    case nowPlaying(MovieResponse)
    case popular(MovieResponse)
    case upcoming(MovieResponse)
    case topRated(MovieResponse)
    case error(Error)
    case setLoading(Bool)
    case selectMovie(Int)
    case tappedSeeAll(MovieListEndpoint)
}

protocol MovieListViewModelDelegate: AnyObject {
    func handleOutput(_ output: MovieListViewModelOutput)
}
