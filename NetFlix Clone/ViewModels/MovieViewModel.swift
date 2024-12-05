//
//  MovieViewModel.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 11/4/24.
//

import Foundation

class MovieViewModel {
    var onMoviesUpdate: (() -> Void)?
    var onUpcomingMoviesUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private(set) var trendingMovies: [Media] = []
    private(set) var upcomingMovies: [Media] = []
    private(set) var popularMovies: [Media] = []
    private(set) var trendingTvs: [Media] = []
    private(set) var topRatedMovies: [Media] = []

    func fetchAllMovies() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchTrendingMovies { dispatchGroup.leave() }
        
        dispatchGroup.enter()
        fetchTrendingTvs { dispatchGroup.leave() }
        
        dispatchGroup.enter()
        fetchPopularMovies { dispatchGroup.leave() }
        
        dispatchGroup.enter()
        fetchUpcomingMovies { dispatchGroup.leave() }
        
        dispatchGroup.enter()
        fetchTopRatedMovies { dispatchGroup.leave() }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.onMoviesUpdate?()
        }
    }
    
    private func fetchTrendingMovies(completion: @escaping () -> Void) {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.trendingMovies = movies
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
            completion()
        }
    }
    
    private func fetchTrendingTvs(completion: @escaping () -> Void) {
        APICaller.shared.getTrendingTvs { [weak self] result in
            switch result {
            case .success(let movies):
                self?.trendingTvs = movies
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
            completion()
        }
    }
    
    private func fetchPopularMovies(completion: @escaping () -> Void) {
        APICaller.shared.getPopularMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.popularMovies = movies
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
            completion()
        }
    }
    
    private func fetchUpcomingMovies(completion: @escaping () -> Void) {
        APICaller.shared.getTrendingUpcomingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.upcomingMovies = movies
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
            completion()
        }
    }
    
    private func fetchTopRatedMovies(completion: @escaping () -> Void) {
        APICaller.shared.getTopRatedMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.topRatedMovies = movies
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
            completion()
        }
    }
    
    func getOnlyUpcomingMovies() {
        APICaller.shared.getTrendingUpcomingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.upcomingMovies = movies
                self?.onUpcomingMoviesUpdate?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
