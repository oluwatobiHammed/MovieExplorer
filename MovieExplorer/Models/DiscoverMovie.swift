//
//  DiscoverMovie.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import RealmSwift
import Realm

@objcMembers
class DiscoverMovie: Object, Decodable {
    private enum CodingKeys: String, CodingKey {
        case page, results, totalPages = "total_pages"
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init()

        let container               = try decoder.container(keyedBy: CodingKeys.self)
        if let results = try container.decodeIfPresent(Array<Discover>.self, forKey: .results) {
            self.results.append(objectsIn: results)
        }
        self.totalPages                     = try container.decode(Int.self, forKey: .totalPages)
        self.page                      = try container.decode(Int.self, forKey: .page)
    }

    override class func primaryKey() -> String? {
        return "id"
    }
    
    dynamic var id                  : Int = 0
    var results                     = List<Discover>()
    dynamic var totalPages          : Int = 0
    dynamic var page                : Int = 0
}
