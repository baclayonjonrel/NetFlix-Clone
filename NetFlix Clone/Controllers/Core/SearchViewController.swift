//
//  SearchViewController.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/4/24.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private var viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or TV show"
        controller.searchBar.searchBarStyle = .default
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        viewModel.fetchDiscoverMovies()
        
        viewModel.$discoverMovies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        setupTableView()
        setupSearchController()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupSearchController() {
        if let resultsController = searchController.searchResultsController as? SearchResultsViewController {
            resultsController.delegate = self
        }
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.searchController?.isActive = true
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = viewModel.discoverMovies[indexPath.row]
        cell.configure(with: title, hideDelete: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.discoverMovies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        viewModel.searchMovies(query: query)
        
        if let resultsController = searchController.searchResultsController as? SearchResultsViewController {
            viewModel.$searchResults
                .receive(on: DispatchQueue.main)
                .sink { movies in
                    resultsController.searchedMovie = movies
                    resultsController.searchResultsCollectionView.reloadData()
                }
                .store(in: &cancellables)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = viewModel.discoverMovies[indexPath.row]
        DispatchQueue.main.async {
            let vc = DetailViewController()
            vc.configure(with: title)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapItem(_ viewModel: Media) {
        DispatchQueue.main.async {
            let vc = DetailViewController()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
