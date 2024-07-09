//
//  HomeViewController.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/4/24.
//

import UIKit

enum Section: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    var randomTrendingMovie: Media? = nil
    private var headerView = HeroHeaderUIView()
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top Rated"]
    var trendingMovie: [Media] = []
    var upcomingMovie: [Media] = []
    var popularMovie: [Media] = []
    var trendingTvs: [Media] = []
    var topRatedMovies: [Media] = []
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: "CollectionViewTableViewCell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.transform = .identity
    }
    
    func configureHeroHeader() {
        APICaller.shared.getPopularMovies { [weak self] result in
            switch result {
            case .success(let movies):
                guard let selectedRandom = movies.randomElement() else {return}
                
                self?.randomTrendingMovie = selectedRandom
                
                let selectedTitle = selectedRandom.original_title ?? selectedRandom.original_name ?? selectedRandom.name
                
                self?.headerView.configure(with: selectedRandom)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "netflixlogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        let searchBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonClick))
        searchBarButtonItem.width = 20
        let profileButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(profileButtonClick))
        searchBarButtonItem.width = 20
        
        navigationItem.rightBarButtonItems = [profileButtonItem, searchBarButtonItem]
    }
    
    @objc func searchButtonClick() {
        print("Search button clicked")
        self.tabBarController?.selectedIndex = 2
    }
    
    @objc func profileButtonClick() {
        print("Profile button clicked")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func getTrendingMovies() {
        APICaller.shared.getTrendingMovies { results in
            switch results {
            case .success(let movies):
                for movie in movies {
                    self.trendingMovie.append(movie)
                }
                for i in 0..<self.trendingMovie.count {
                    print("Trending Movie: \(self.trendingMovie[i].original_title ?? self.trendingMovie[i].original_name ?? "Untitled")")
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private func getTrendingTvs() {
        APICaller.shared.getTrendingTvs { results in
            switch results {
            case .success(let tvs):
                for tv in tvs {
                    self.trendingTvs.append(tv)
                }
                for i in 0..<self.trendingTvs.count {
                    print("Trending TV: \(self.trendingTvs[i].name ?? "Untitled")")
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private func getUpcomingMovies() {
        APICaller.shared.getTrendingUpcomingMovies { results in
            switch results {
            case .success(let movies):
                for movie in movies {
                    self.upcomingMovie.append(movie)
                }
                for i in 0..<self.upcomingMovie.count {
                    print("Upcoming Movie: \(self.upcomingMovie[i].original_title ?? self.upcomingMovie[i].original_name ?? "Untitled")")
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private func getPopularMovies() {
        APICaller.shared.getPopularMovies { results in
            switch results {
            case .success(let movies):
                for movie in movies {
                    self.popularMovie.append(movie)
                }
                for i in 0..<self.popularMovie.count {
                    print("popular Movie: \(self.popularMovie[i].original_title ?? self.popularMovie[i].original_name ?? "Untitled")")
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private func getTopRatedMovies() {
        APICaller.shared.getTopRatedMovies { results in
            switch results {
            case .success(let movies):
                for movie in movies {
                    self.topRatedMovies.append(movie)
                }
                for i in 0..<self.topRatedMovies.count {
                    print("Top Rated Movie: \(self.topRatedMovies[i].original_title ?? self.topRatedMovies[i].original_name ?? "Untitled")")
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Section.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { results in
                switch results {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
            }
        case Section.TrendingTV.rawValue:
            APICaller.shared.getTrendingTvs { results in
                switch results {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Popular.rawValue:
            APICaller.shared.getPopularMovies { results in
                switch results {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
            }
        case Section.Upcoming.rawValue:
            APICaller.shared.getTrendingUpcomingMovies { results in
                switch results {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
            }
        case Section.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { results in
                switch results {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.lowercased().capitalized(with: .autoupdatingCurrent)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: Media) {
        DispatchQueue.main.async {
            let vc = DetailViewController()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
