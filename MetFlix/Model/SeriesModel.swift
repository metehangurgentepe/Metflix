//
//  SeriesModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 3.10.2024.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let seriesResponse = try? JSONDecoder().decode(SeriesResponse.self, from: jsonData)

import Foundation

// MARK: - SeriesResponse
struct SeriesResponse: Codable {
    let page: Int?
    let results: [Series]
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages
        case totalResults
    }
}

// MARK: - Result
struct Series: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originCountry: [String]?
    let originalLanguage, originalName, overview: String?
    let popularity: Double?
    let posterPath, firstAirDate, name: String?
    let voteAverage: Double?
    let voteCount: Int?
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w780\(posterPath ?? "")")!
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath
        case genreIDS
        case id
        case originCountry
        case originalLanguage
        case originalName
        case overview, popularity
        case posterPath
        case firstAirDate
        case name
        case voteAverage
        case voteCount
    }
}
