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
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {return}
            
            //            if let JSONString = String(data: data, encoding: String.Encoding.utf8)
            //                {
            //                    print(JSONString)
            //                }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {return}
            
            //            if let JSONString = String(data: data, encoding: String.Encoding.utf8)
            //                {
            //                    print(JSONString)
            //                }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    func getTrendingUpcomingMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {return}
            
            //            if let JSONString = String(data: data, encoding: String.Encoding.utf8)
            //                {
            //                    print(JSONString)
            //                }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
            
            
            
        }
        task.resume()
        
    }
    
    func getPopularMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {return}
            
            //            if let JSONString = String(data: data, encoding: String.Encoding.utf8)
            //                {
            //                    print(JSONString)
            //                }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
            
            
            
        }
        task.resume()
        
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {return}
            
            //            if let JSONString = String(data: data, encoding: String.Encoding.utf8)
            //                {
            //                    print(JSONString)
            //                }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization=flatrate") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {return}
            
            //            if let JSONString = String(data: data, encoding: String.Encoding.utf8)
            //                {
            //                    print(JSONString)
            //                }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Media], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {return}
            
            //            if let JSONString = String(data: data, encoding: String.Encoding.utf8)
            //                {
            //                    print(JSONString)
            //                }
            
            do {
                let results = try JSONDecoder().decode(MediaResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {return}
            
            do {
                let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                //print(results)
                completion(.success(results.items[0]))
            } catch {
                print(error)
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
}
