//
//  ProfileViewModelContracts.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//

import Foundation

protocol ProfileViewModelProtocol {
    var delegate: ProfileViewModelDelegate? { get set }
    func load() async
    func selectMovie(id: Int)
    func tappedSeeAll(endpoint: MovieListEndpoint)
}

enum ProfileViewModelOutput {
    case likedMovies(MovieResponse)
    case myList(MovieResponse)
    case error(MovieError)
    case setLoading(Bool)
    case selectMovie(Int)
}

protocol ProfileViewModelDelegate: AnyObject {
    func handleOutput(_ output: ProfileViewModelOutput)
}
