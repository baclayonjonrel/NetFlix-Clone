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
    
    var viewModel = MovieViewModel()
    var randomTrendingMovie: Media? = nil
    private var headerView = HeroHeaderUIView()
    private var hasErrorOccurred: Bool = false
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top Rated"]
    
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
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: UIScreen.main.bounds.height * 0.65))
        homeFeedTable.tableHeaderView = headerView
        
        viewModel.onMoviesUpdate = { [weak self] in
            self?.homeFeedTable.reloadData()
            self?.configureHeroHeader()
        }
        viewModel.onError = { [weak self] error in
            self?.handleError(error)
        }
        viewModel.fetchAllMovies()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.transform = .identity
    }
    
    func configureHeroHeader() {
        if let selectedRandom = viewModel.popularMovies.randomElement() {
            self.randomTrendingMovie = selectedRandom
            self.headerView.configure(with: selectedRandom)
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
        if hasErrorOccurred {
            return cell
        }
        switch indexPath.section {
        case Section.TrendingMovies.rawValue:
            cell.configure(with: viewModel.trendingMovies)
        case Section.TrendingTV.rawValue:
            cell.configure(with: viewModel.trendingTvs)
        case Section.Popular.rawValue:
            cell.configure(with: viewModel.popularMovies)
        case Section.Upcoming.rawValue:
            cell.configure(with: viewModel.upcomingMovies)
        case Section.TopRated.rawValue:
            cell.configure(with: viewModel.topRatedMovies)
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
        header.textLabel?.text = header.textLabel?.text?.lowercased().capitalized(with: .autoupdatingCurrent)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    private func handleError(_ error: String) {
        guard !hasErrorOccurred else { return }
        hasErrorOccurred = true
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 3
        }
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
