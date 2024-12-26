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
    static let YouTubeAPI_KEY = "AIzaSyAOkIiPJ5NuPxD_VUYS88cIvNxztPlnwZM"
    static let YouTubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search"
}

enum APIError: Error{
    case failedToGetData
    case invalidURL
    case noData
}

class APICaller{
    static let shared = APICaller()
    
    func getTrendingMovies(language: String = "en-US", completion: @escaping (Result<[Title], Error>) -> Void) {
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
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getTrendingTv(language: String = "en-US", completion: @escaping (Result<[Title], Error>) -> Void) {
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
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getPopular(language: String = "en-US", completion: @escaping (Result<[Title], Error>) -> Void) {
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
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(language: String = "en_US", completion: @escaping(Result<[Title], Error>) -> Void ) {
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
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getTopRatedMovies (language: String = "en_US", completion: @escaping(Result<[Title], Error>) -> Void ) {
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
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getDiscoverMovies (language: String = "en_US", completion: @escaping(Result<[Title], Error>) -> Void ) {
        var components = URLComponents(string: "\(Constants.baseURL)/3/discover/movie")
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_Key),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "include_video", value: "false"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "with_watch_monetization_types", value: "flatrate")
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
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func search(query: String, language: String = "en_US", completion: @escaping(Result<[Title], Error>) -> Void ) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        var components = URLComponents(string: "\(Constants.baseURL)/3/search/movie")
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: Constants.API_Key),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "query", value: query)
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
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getVideo(query: String, completion: @escaping(Result<YouTubeElement, Error>) -> Void ) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }

        guard let url = URL(string: "\(Constants.YouTubeBaseURL)?q=\(query)&key=\(Constants.YouTubeAPI_KEY)") else { return }
        
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
                let results = try JSONDecoder().decode(YouTubeVideoResponse.self, from: data)
                completion(.success(results.items[0]))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}
