//
//  MockNetwork.swift
//  MovieExplorerTests
//
//  Created by Oluwatobi Oladipupo on 11/06/2023.
//

import Foundation
@testable import MovieExplorer
import XCTest

struct MockNetworkManager: ManagerProtocol {
    let router = Router<MovieEndpoints>()
    
    
    func getSearch(page: Int, query: String, completion: @escaping (_ movies: Movies?, _ error: Error?)->()) {
        Task {
            
            if let file = Bundle.main.url(forResource: "movies", withExtension: "json") {
                let jsonData = try? Data(contentsOf: file)
                        guard let responseData = jsonData else {
                            completion(nil, NSError(domain: "", code: 20, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.noData.rawValue]))
                            return
                        }
                        do {
                            
                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            print(jsonData)
                            
                            guard let movies = try? Movies.decode(data: responseData) else {
                                completion(nil, NSError(domain: "", code: 15, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue]))
                                return
                            }
                            completion(movies,nil)
                            guard movies.results.count > 0 else { return }
                            DispatchQueue.main.async {
                                if page == 1 {
                                    MovieRealmManager.shared.deleteDatabase()
                                }
                                
                                MovieRealmManager.shared.updateOrSave(realmObject: movies)
                            }
                            
                        } catch {
                            
                            completion(nil, NSError(domain: "", code: 10, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue]))
                        }
            }
         
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Error> {
        switch response.statusCode {
        case 200...299: return .success
        case 404: return .success
        case 401...500: return .failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.authenticationError.rawValue]))
        case 501...599: return .failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.badRequest.rawValue]))
        case 600: return .failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.outdated.rawValue]))
        default: return .failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.failed.rawValue]))
        }
    }
}
