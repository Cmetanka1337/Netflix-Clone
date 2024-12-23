//
//  API Caller.swift
//  Netflix Clone
//
//  Created by Всеволод Буртик on 17.12.2024.
//

import Foundation

struct Constants {
    static let API_Key = "23a242357ff07c9035e34352ee363c2e"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error{
    
}

class APICaller{
    static let shared = APICaller()
    
    func getTrendingMovies(language: String = "en-US", completion: @escaping (Result<[Movie], Error>) -> Void) {
        var components = URLComponents(string: "\(Constants.baseURL)/3/trending/movie/day")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_Key),
            URLQueryItem(name: "language", value: language)
        ]
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "Accept": "application/json"
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getTrendingTv(language: String = "en-US", completion: @escaping (Result<[Tv], Error>) -> Void) {
        var components = URLComponents(string: "\(Constants.baseURL)/3/trending/tv/day")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_Key),
            URLQueryItem(name: "language", value: language)
        ]
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "Accept": "application/json"
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTvResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getPopular(language: String = "en-US", completion: @escaping (Result<[Tv], Error>) -> Void) {
        var components = URLComponents(string: "\(Constants.baseURL)/3/movie/popular")!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_Key),
            URLQueryItem(name: "language", value: language)
        ]
        
        guard let url = components.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "Accept": "application/json"
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do{
                let results = try JSONDecoder().decode(TrendingTvResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(language: String = "en_US", completion: @escaping(Result<[Movie], Error>) -> Void ) {
        var components = URLComponents(string: "\(Constants.baseURL)/3/movie/upcoming")
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_Key),
            URLQueryItem(name: "languge", value: language)
        ]
        
        guard let url = components?.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "Accept" : "application/json"
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getTopRatedMovies (language: String = "en_US", completion: @escaping(Result<[Movie], Error>) -> Void ) {
        var components = URLComponents(string: "\(Constants.baseURL)/3/movie/top_rated")
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_Key),
            URLQueryItem(name: "language", value: language)
        ]
        
        guard let url = components?.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "Accept" : "application/json"
        ]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}
