//
//  SeeAllViewModelContracts.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 21.02.2024.
//

import Foundation

protocol SeeAllViewModelProtocol {
    var delegate: SeeAllViewModelDelegate? { get set }
    func load()
}

enum SeeAllViewModelOutput {
    case movieList([Movie])
    case error(Error)
    case selectMovie(Int)
    case setLoading(Bool)
}


protocol SeeAllViewModelDelegate: AnyObject {
    func handleOutput(_ output: SeeAllViewModelOutput)
}
