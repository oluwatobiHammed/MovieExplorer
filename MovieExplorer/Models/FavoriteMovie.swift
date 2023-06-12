//
//  FavoriteMovie.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 12/06/2023.
//

import RealmSwift
import Realm

@objcMembers
class FavoriteMovie: Object, Decodable {
    private enum CodingKeys: String, CodingKey {
        case id,  backdropPath = "backdrop_path", genreIds = "genre_ids", originalLanguage = "original_language", originalTitle = "original_title", overview, popularity, posterPath = "poster_path", releaseDate = "release_date", title, video, voteAverage = "vote_average",
             voteCount = "vote_count"
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init()

        let container               = try decoder.container(keyedBy: CodingKeys.self)
        self.id                     = try container.decode(Int.self, forKey: .id)
        self.originalLanguage       = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.originalTitle          = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.popularity             = try container.decode(Double.self, forKey: .popularity)
        self.overview               = try container.decodeIfPresent(String.self, forKey: .overview)
        self.posterPath             = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.backdropPath           = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.releaseDate            = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        self.title                  = try container.decodeIfPresent(String.self, forKey: .title)
        self.video                  = try container.decode(Bool.self, forKey: .video)
        self.voteAverage            = try container.decode(Double.self, forKey: .voteAverage)
        self.voteCount              = try container.decode(Int.self, forKey: .voteCount)

    }

    override class func primaryKey() -> String? {
        return "id"
    }
    
    dynamic var id                    : Int = 0
    dynamic var backdropPath          : String?
    dynamic var originalLanguage      : String?
    dynamic var originalTitle         : String?
    dynamic var overview              : String?
    dynamic var popularity            : Double = 0.0
    dynamic var posterPath            : String?
    dynamic var releaseDate           : String?
    dynamic var title                 : String?
    dynamic var video                 : Bool = false
    dynamic var voteAverage           : Double = 0.0
    dynamic var voteCount             : Int = 0
}

