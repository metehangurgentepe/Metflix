//
//  SearchViewModelContracts.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 21.02.2024.
//

import Foundation

protocol SearchViewModelProtocol {
    var delegate: SearchViewModelDelegate? { get set }
    func load()
    func search(filter: String)
}

enum SearchViewModelOutput {
    case getMoviesBySearch([Movie])
    case loadMovies([Movie])
    case setLoading(Bool)
    case selectMovie(Int)
    case error(Error)
}

protocol SearchViewModelDelegate: AnyObject {
    func handleOutput(_ output: SearchViewModelOutput)
}
