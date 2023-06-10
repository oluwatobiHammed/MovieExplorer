//
//  MovieRealmManager.swift
//  MovieExplorer
//
//  Created by Oluwatobi Oladipupo on 09/06/2023.
//

import Foundation
import  RealmSwift

class MovieRealmManager {
    
    static let shared = MovieRealmManager()
    static let SCHEMA_VERSION: UInt64 = 12
    
    lazy var config: Realm.Configuration = {
        let config = Realm.Configuration(schemaVersion: MovieRealmManager.SCHEMA_VERSION, deleteRealmIfMigrationNeeded: true)
        return config
    }()
    
    
    lazy var realm = try? Realm(configuration: config)
    
    func deleteDatabase() {
        try? realm?.write({
            realm?.deleteAll()
        })
    }
    
    func updateOrSave(realmObject: Object) {
        try? realm?.write ({
            guard !realmObject.isInvalidated else { return }
            realm?.add(realmObject, update: .all)
        })
    }
    
    func fetchObjects(type: Object.Type) -> Results<Object>? {
        return realm?.objects(type)
    }
    
}


extension MovieRealmManager {
    
    
    var movies : Movies? {
        
        let results = fetchObjects(type: Movies.self)
        if let results = results, !results.isInvalidated,  results.count > 0 {
            return results.first as? Movies
        }
        return nil
        
    }
}
