//
//  FavoriteViewModelContracts.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 21.02.2024.
//

import Foundation

protocol FavoriteViewModelProtocol {
    var delegate: FavoriteViewModelDelegate? { get set }
    func load()
    func filter(_ genreName: String)
}

enum FavoriteViewModelOutput{
    case favoriteList([Movie])
    case error(MovieError)
    case selectMovie(Int)
    case filter(String)
}

protocol FavoriteViewModelDelegate: AnyObject {
    func handleOutput(_ output: FavoriteViewModelOutput)
}



