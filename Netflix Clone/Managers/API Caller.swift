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
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/all/day?api_key=\(Constants.API_Key)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription as Any)
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
