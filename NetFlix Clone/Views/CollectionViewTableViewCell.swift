//
//  CollectionViewTableViewCell.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/4/24.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: Media)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    private var movieViewModel: MoviePersistenceViewModel!
    private var movies: [Media] = [Media]()
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(collectionView)
         
        collectionView.delegate = self
        collectionView.dataSource = self
        movieViewModel = MoviePersistenceViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with movie: [Media]) {
        movies = movie
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        print("Dowloading to database \(movies[indexPath.row].original_title ?? movies[indexPath.row].original_name ?? movies[indexPath.row].name ?? "")")
        if !movieViewModel.isMovieSaved(id: Int64(movies[indexPath.row].id)) {
            downloadMovie(model: movies[indexPath.row])
        }
    }
    
    func downloadMovie(model: Media) {
        movieViewModel.downloadMovie(model: model)
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: movies[indexPath.row].poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = movies[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title ?? title.name else {
            return
        }
        
        self.delegate?.CollectionViewTableViewCellDidTapCell(self, viewModel: self.movies[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil, 
            previewProvider: nil) { _ in
                let downloadAction = UIAction(title: "Save to list") { _ in
                    self.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", options: .displayInline, children: [downloadAction])
            }
        return config
    }
    
    
    
}
