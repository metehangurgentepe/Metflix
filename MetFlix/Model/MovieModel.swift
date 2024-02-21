//
//  Movie.swift
//  SwiftUIMovieDb
//
//  Created by Alfian Losari on 23/05/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
}


struct Movie: Codable, Identifiable, Hashable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(backdropPath, forKey: .backdropPath)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(overview, forKey: .overview)
        try container.encode(voteAverage, forKey: .voteAverage)
        try container.encode(voteCount, forKey: .voteCount)
        try container.encode(runtime, forKey: .runtime)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(homepage, forKey: .homepage)
        if let genres = genres {
            try container.encode(genres, forKey: .genres)
        }
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    let homepage: String?

    let genres: [MovieGenre]?
    let credits: MovieCredit?
    let videos: MovieVideoResponse?

    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()

    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()

    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath ?? "")")!
    }

    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w780\(posterPath ?? "")")!
    }

    var genreText: String {
        genres?.first?.name ?? "n/a"
    }

    var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        return ratingText
    }

    var scoreText: String {
        guard ratingText.count > 0 else {
            return "n/a"
        }
        return "\(ratingText.count)/10"
    }

    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Movie.yearFormatter.string(from: date)
    }

    var durationText: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return "n/a"
        }
        return Movie.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }

    var cast: [MovieCast]? {
        credits?.cast
    }

    var crew: [MovieCrew]? {
        credits?.crew
    }

    var directors: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }

    var producers: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }

    var screenWriters: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "story" }
    }

    var youtubeTrailers: [MovieVideo]? {
        videos?.results.filter { $0.youtubeURL != nil }
    }

}

struct MovieGenre: Codable {
    let name: String
}

struct MovieCredit: Decodable {
    let cast: [MovieCast]
    let crew: [MovieCrew]
}

struct MovieCast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
}

struct MovieCrew: Decodable, Identifiable {
    let id: Int
    let job: String
    let name: String
}

struct MovieVideoResponse: Decodable {
    let results: [MovieVideo]
}

struct MovieVideo: Decodable, Identifiable {

    let id: String
    let key: String
    let name: String
    let site: String

    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}
