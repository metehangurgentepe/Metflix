//
//  MovieImagesModel.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 8.02.2024.
//

import Foundation


struct MovieImagesModel: Codable {
    let backdrops: [Backdrop]
    let id: Int
    let logos, posters: [Backdrop]
}

struct Backdrop: Codable {
    let aspectRatio: Double
    let height: Int
    let iso639_1: String?
    let filePath: String
    let voteAverage: Double
    let voteCount, width: Int
}
