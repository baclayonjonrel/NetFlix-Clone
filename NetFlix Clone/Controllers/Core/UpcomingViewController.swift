//
//  UpcomingViewController.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/4/24.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var upcomingMovies: [Media] = [Media]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Coming soon"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        fetchUpcoming()
        
        view.addSubview(upcomingTable)
        upcomingTable.dataSource = self
        upcomingTable.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getTrendingUpcomingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.upcomingMovies = movies
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = upcomingMovies[indexPath.row]
        cell.configure(with: title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = upcomingMovies[indexPath.row]
        
        DispatchQueue.main.async {
            let vc = DetailViewController()
            vc.configure(with: title)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
