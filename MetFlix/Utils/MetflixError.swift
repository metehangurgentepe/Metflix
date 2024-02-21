//
//  MetflixError.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 12.02.2024.
//

import Foundation


enum MetflixError: String, Error{
    case invalidUsername = "This username created an invalid request. Please try again"
    case networkError = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "There is server error."
    case invalidData = "The data received from the server was invalid. Try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "Already added favorites"
}
