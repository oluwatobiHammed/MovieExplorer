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
    
    func deleteObject(realmObject : Object, isCascading: Bool = false) {
        try? realm?.write ({
            guard !realmObject.isInvalidated else { return }
            realm?.delete(realmObject)
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
    
    func clearDailySearchMovies() {
        DispatchQueue.main.async { [self] in
            clearObject(type: Movies.self, isCascading: false)
        }
    }
    
    func clearObject(type: Object.Type, isCascading: Bool = false) {
        try? realm?.write ({
            if let result = realm?.objects(type.self) {
                guard !result.isInvalidated || result.first != nil else { return }
                realm?.delete(result)
            }
        })
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
    
    var favoriteMovies : FavoriteMovies? {
        
        let results = fetchObjects(type: FavoriteMovies.self)
        if let results = results, !results.isInvalidated,  results.count > 0 {
            return results.first as? FavoriteMovies
        }
        return nil
        
    }
}
