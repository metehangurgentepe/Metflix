//
//  ProfileViewModelContracts.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//

import Foundation

protocol ProfileViewModelProtocol: AnyObject {
    var delegate: ProfileViewModelDelegate? { get set }
    func loadData() async
    func selectMovie(id: Int)
}

enum ProfileViewModelOutput {
    case likedMovies([Movie])
    case myList([Movie])
    case error(MovieError)
    case setLoading(Bool)
    case selectMovie(Int)
}

protocol ProfileViewModelDelegate: AnyObject {
    func handleOutput(_ output: ProfileViewModelOutput)
}
