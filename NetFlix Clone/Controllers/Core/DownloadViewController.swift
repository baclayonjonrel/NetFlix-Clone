//
//  DownloadViewController.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/4/24.
//

import UIKit

class DownloadViewController: UIViewController {
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchDownloadedMovie()
    }
    
    private func fetchDownloadedMovie() {
        DataPersistenceManager.shared.fetchMovieFromDatabase { [weak self] result in
            switch result {
            case .success(let movies):
                self?.downloadedMovies = movies
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
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
        let title = downloadedMovies[indexPath.row].name ?? downloadedMovies[indexPath.row].original_name ?? downloadedMovies[indexPath.row].original_title ?? ""
        let posterPath = "https://image.tmdb.org/t/p/w500\(downloadedMovies[indexPath.row].poster_path ?? "")"
        cell.configure(with: TitleViewModel(titleName: title, posterURL: posterPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = downloadedMovies[indexPath.row].name ?? downloadedMovies[indexPath.row].original_name ?? downloadedMovies[indexPath.row].original_title ?? ""
        
        APICaller.shared.getMovie(with: title) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = PreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: title, youtubeVideo: videoElement, description: self?.downloadedMovies[indexPath.row].overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteMovieOnDatabase(model: downloadedMovies[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("deleted form Database")
                    self?.downloadedMovies.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
            
        default:
            break;
        }
    }
}