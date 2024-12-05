//
//  DownloadViewController.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/4/24.
//

import UIKit

class DownloadViewController: UIViewController {
    
    private var movieViewModel: MoviePersistenceViewModel!
    private var downloadedMovies: [MovieItem] = [MovieItem]()

    private let downloadedTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadedTable.dataSource = self
        downloadedTable.delegate = self
        
        view.addSubview(downloadedTable)
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = false
        movieViewModel = MoviePersistenceViewModel()
        movieViewModel.onMoviesUpdate = { [weak self] in
            self?.downloadedMovies = self?.movieViewModel.savedMovies ?? []
            DispatchQueue.main.async {
                self?.downloadedTable.reloadData()
            }
        }
        
        movieViewModel.onError = { errorMessage in
            print(errorMessage)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        movieViewModel.fetchSavedMovies()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
    
    func deleteMovie(model: MovieItem) {
        movieViewModel.deleteMovie(model: model)
    }
}

extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let movieItem = downloadedMovies[indexPath.row]
        let title = Media(id: Int(movieItem.id), media_type: movieItem.media_type, original_name: movieItem.original_name, original_title: movieItem.original_title, poster_path: movieItem.poster_path, overview: movieItem.overview, vote_count: Int(movieItem.vote_count), release_date: movieItem.release_date, vote_average: movieItem.vote_average, name: movieItem.name)
        cell.delegate = self
        cell.configure(with: title, hideDelete: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movieItem = downloadedMovies[indexPath.row]
        let title = Media(id: Int(movieItem.id), media_type: movieItem.media_type, original_name: movieItem.original_name, original_title: movieItem.original_title, poster_path: movieItem.poster_path, overview: movieItem.overview, vote_count: Int(movieItem.vote_count), release_date: movieItem.release_date, vote_average: movieItem.vote_average, name: movieItem.name)
        
        DispatchQueue.main.async {
            let vc = DetailViewController()
            vc.configure(with: title)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteMovie(model: downloadedMovies[indexPath.row])
        default:
            break;
        }
    }
}

extension DownloadViewController: DownloadViewControllerDelegate {
    func deleteMovie(movie: Media) {
        if let index = downloadedMovies.firstIndex(where: { $0.id == movie.id} ) {
            deleteMovie(model: downloadedMovies[index])
        }
    }
}
