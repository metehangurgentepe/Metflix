//
//  MovieError.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 23.02.2024.
//

import Foundation

enum MovieError: Error {
    case apiError
    case invalidEndpoint
    case noData
    case invalidResponse
    case serializationError
    case unableToFavorite
    case alreadyInFavorites
    
    var localizedDescription: String{
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        case .unableToFavorite: return "There was an error favoriting this user. Please try again."
        case .alreadyInFavorites: return "Already added favorites"
        }
    }
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}
