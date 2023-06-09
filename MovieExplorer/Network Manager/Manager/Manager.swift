//
//  Manager.swift
//  MovieDetails
//
//  Created by Oladipupo Oluwatobi on 08/06/2023.
//

import Foundation

struct NetworkManager: ManagerProtocol {
    
    func addFavorite(movieId: Int, isfavorite: Bool, completion: @escaping (Result<Error>)-> Void) {
        Task {
            await router.request(.addFavorite(movie: movieId, isfavorite: isfavorite)) { data, response, error in
                
                if error != nil {
                    completion(.failure(NSError(domain: "", code: URLError.Code.notConnectedToInternet.rawValue, userInfo: [NSLocalizedDescriptionKey : "Please check your network connection."])))
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.noData.rawValue])))
                            return
                        }
                        do {

                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            print(jsonData)
                            completion(.success)
                        } catch {

                            completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue])))
                        }
                    case .failure(let networkFailureError):
                        completion(.failure(networkFailureError))
                    }
                }
            }
        }
    }
    
    func getFavorite(page: Int, completion: @escaping (ApiResults<FavoriteMovies>) -> Void) {
        Task {
            await router.request(.getFavorite(page: page)) { data, response, error in
                
                if error != nil {
                    completion(.failure(NSError(domain: "", code: URLError.Code.notConnectedToInternet.rawValue, userInfo: [NSLocalizedDescriptionKey : "Please check your network connection."])))
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(.failure (NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.noData.rawValue])))
                            return
                        }
                        do {

                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            print(jsonData)
                            
                            guard let movies = try? FavoriteMovies.decode(data: responseData) else {
                                completion(.failure (NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue])))
                                return
                            }
                            completion(.success(movies))
                            guard movies.results.count > 0 else { return }
                            DispatchQueue.main.async {
                                
                                MovieRealmManager.shared.updateOrSave(realmObject: movies)
                            }
                           
                        } catch {

                            completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue])))
                        }
                    case .failure(let networkFailureError):
                        completion(.failure(networkFailureError))
                    }
                }
            }
        }
        
    }
    
    
    let router = Router<MovieEndpoints>()
    
    
    func getSearch(page: Int, query: String, completion: @escaping (ApiResults<Movies>) -> Void) {
        Task {
            await router.request(.search(query: query, page: page)) { data, response, error in
                
                if error != nil {
                    completion(.failure(NSError(domain: "", code: URLError.Code.notConnectedToInternet.rawValue, userInfo: [NSLocalizedDescriptionKey : "Please check your network connection."])))
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.noData.rawValue])))
                            return
                        }
                        do {

                            let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                            print(jsonData)
                            
                            guard let movies = try? Movies.decode(data: responseData) else {
                                completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue])))
                                return
                            }
                            completion(.success(movies))
                           
                        } catch {

                            completion(.failure(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : NetworkResponse.unableToDecode.rawValue])))
                        }
                    case .failure(let networkFailureError):
                        completion(.failure(networkFailureError))
                    }
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


enum ApiResults<T> {
    case success(T)
    case failure(Error)
}
