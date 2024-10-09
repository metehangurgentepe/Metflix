//
//  SearchViewModelContracts.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 9.10.2024.
//

import Foundation


protocol SelectProfileViewModelProtocol {
    var delegate: SelectProfileViewModelDelegate? { get set }
    func fetchUsers()
}

enum SelectProfileViewModelOutput {
    case error(MovieError)
    case fetchUsers([User])
}

protocol SelectProfileViewModelDelegate: AnyObject {
    func handleOutput(_ output: SelectProfileViewModelOutput)
}
