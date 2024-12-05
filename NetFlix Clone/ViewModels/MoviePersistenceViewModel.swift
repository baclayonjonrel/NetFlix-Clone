//
//  MoviePersistenceViewModel.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 11/4/24.
//

import Foundation

class MoviePersistenceViewModel {
    private let dataPersistenceManager: DataPersistenceManager
    private(set) var savedMovies: [MovieItem] = []
    
    var onMoviesUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(dataPersistenceManager: DataPersistenceManager = DataPersistenceManager.shared) {
        self.dataPersistenceManager = dataPersistenceManager
    }
    
    func fetchSavedMovies() {
        dataPersistenceManager.fetchMovieFromDatabase { [weak self] result in
            switch result {
            case .success(let movies):
                self?.savedMovies = movies
                self?.onMoviesUpdate?()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func downloadMovie(model: Media) {
        dataPersistenceManager.downloadMovieWith(model: model) { [weak self] result in
            switch result {
            case .success:
                self?.fetchSavedMovies()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func deleteMovie(model: MovieItem) {
        dataPersistenceManager.deleteMovieOnDatabase(model: model) { [weak self] result in
            switch result {
            case .success:
                self?.fetchSavedMovies()
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
    
    func isMovieSaved(id: Int64) -> Bool {
        return dataPersistenceManager.isMovieSaved(id: id)
    }
}
