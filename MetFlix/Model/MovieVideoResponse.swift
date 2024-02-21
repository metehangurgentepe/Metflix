//
//  MovieVideoResponse.swift
//  MetFlix
//
//  Created by Metehan Gürgentepe on 15.02.2024.
//

import Foundation

struct MovieVideoModel: Codable {
    var id: Int
    var results: [VideoResult]
}

struct VideoResult: Codable {
    var name: String
    var key: String
    var site: String
}
