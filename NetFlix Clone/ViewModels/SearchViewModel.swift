//
//  SearchViewModel.swift
//  NetFlix Clone
//
//  Created by TVStartup on 12/5/24.
//

import Combine
import Foundation

class SearchViewModel {
    @Published var discoverMovies: [Media] = []
    @Published var searchResults: [Media] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.discoverMovies = movies
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchMovies(query: String) {
        APICaller.shared.search(with: query) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.searchResults = movies
            case .failure(let error):
                print(error)
            }
        }
    }
}
