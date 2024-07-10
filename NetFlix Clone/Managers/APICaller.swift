//
//  APICaller.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/4/24.
//

import Foundation
//166f80c9f657e9f3c45bbc52370ba257

struct Constants {
    static let API_KEY = "166f80c9f657e9f3c45bbc52370ba257"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDu7u7LPEEF1NF5Bougo_b_xAhmqub1zwA"
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case failedStatusCode(Int)
    case noData
    case failedToGetData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .invalidResponse:
            return "The response is invalid."
        case .failedStatusCode(let statusCode):
            return "Request failed with status code \(statusCode)."
        case .noData:
            return "No data was returned."
        case .failedToGetData:
            return "Failed to decode the data."
        }
    }
}


class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        let url = "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)"
        
        performRequest(urlString: url, method: "GET", responseType: MediaResponse.self) { response in
            switch response {
            case .success(let results):
                completion(.success(results.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Media], Error>) -> Void) {
        let url = "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)"
        
        performRequest(urlString: url, method: "GET", responseType: MediaResponse.self) { response in
            switch response {
            case .success(let results):
                completion(.success(results.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTrendingUpcomingMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        let url = "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)"
        
        performRequest(urlString: url, method: "GET", responseType: MediaResponse.self) { response in
            switch response {
            case .success(let results):
                completion(.success(results.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func getPopularMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        let url = "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)"
        
        performRequest(urlString: url, method: "GET", responseType: MediaResponse.self) { response in
            switch response {
            case .success(let results):
                completion(.success(results.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        let url = "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)"
        
        performRequest(urlString: url, method: "GET", responseType: MediaResponse.self) { response in
            switch response {
            case .success(let results):
                completion(.success(results.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        let url = "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization=flatrate"
        
        performRequest(urlString: url, method: "GET", responseType: MediaResponse.self) { response in
            switch response {
            case .success(let results):
                completion(.success(results.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func search(with query: String, completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        let url = "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)"
        
        performRequest(urlString: url, method: "GET", responseType: MediaResponse.self) { response in
            switch response {
            case .success(let results):
                completion(.success(results.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performRequest<T: Decodable>(urlString: String, method: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.failedStatusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(responseType, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
}
