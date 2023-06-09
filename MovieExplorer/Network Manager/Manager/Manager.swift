//
//  Manager.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import Foundation

struct NetworkManager {
    let router = Router<MovieEndpoints>()
    
    
    
    func getDiscover(page: Int, completion: @escaping (_ review: DiscoverMovie?, _ error: Error?)->()) {
        Task {
            await router.request(.getMovies(page: page)) { data, response, error in
                
                if error != nil {
                    completion(nil, NSError(domain: "", code: URLError.Code.notConnectedToInternet.rawValue, userInfo: [NSLocalizedDescriptionKey : "Please check your network connection."]))
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.noData.rawValue]))
                            return
                        }
                        do {

                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            print(jsonData)
                            
                            guard let review = try? DiscoverMovie.decode(data: responseData) else {
                                completion(nil, NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue]))
                                return
                            }
                            completion(review,nil)
                        }catch {

                            completion(nil, NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue]))
                        }
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                    }
                }
            }
        }
    }
    
    func getNowPlaying(page: Int, completion: @escaping (_ review: DiscoverMovie?, _ error: Error?)->()) {
        Task {
            await router.request(.getNowPlayinMovies(page: page)) { data, response, error in
                
                if error != nil {
                    completion(nil, NSError(domain: "", code: URLError.Code.notConnectedToInternet.rawValue, userInfo: [NSLocalizedDescriptionKey : "Please check your network connection."]))
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.noData.rawValue]))
                            return
                        }
                        do {

                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            print(jsonData)
                            
                            guard let review = try? DiscoverMovie.decode(data: responseData) else {
                                completion(nil, NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue]))
                                return
                            }
                            completion(review,nil)
                        }catch {

                            completion(nil, NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue]))
                        }
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                    }
                }
            }
        }
    }
    
    
    func getSearch(page: Int, query: String, completion: @escaping (_ movies: DiscoverMovie?, _ error: Error?)->()) {
        Task {
            await router.request(.search(query: query, page: page)) { data, response, error in
                
                if error != nil {
                    completion(nil, NSError(domain: "", code: URLError.Code.notConnectedToInternet.rawValue, userInfo: [NSLocalizedDescriptionKey : "Please check your network connection."]))
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.noData.rawValue]))
                            return
                        }
                        do {

                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            print(jsonData)
                            
                            guard let movies = try? DiscoverMovie.decode(data: responseData) else {
                                completion(nil, NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue]))
                                return
                            }
                            guard movies.results.count > 0 else { return }
                            completion(movies,nil)
                        } catch {

                            completion(nil, NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue]))
                        }
                    case .failure(let networkFailureError):
                        completion(nil, networkFailureError)
                    }
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Error>{
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
