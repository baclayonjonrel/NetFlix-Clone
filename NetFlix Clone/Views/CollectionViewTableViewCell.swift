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
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
         
        collectionView.delegate = self
        collectionView.dataSource = self
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
//        for mov in movies {
//            print(mov.original_name ?? mov.original_title ?? mov.name)
//        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        print("Dowloading to database \(movies[indexPath.row].original_title ?? movies[indexPath.row].original_name ?? movies[indexPath.row].name ?? "")")
        DataPersistenceManager.shared.downloadMovieWith(model: movies[indexPath.row]) { result in
            switch result {
            case .success(let success):
                print("saving successfull")
            case .failure(let failure):
                print("failed to save")
            }
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(withL: movies[indexPath.row].poster_path ?? "")
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
//        APICaller.shared.getMovie(with: titleName + " trailer") { result in
//            switch result {
//            case .success(let video):
//                
//                let title = self.movies[indexPath.row].original_name ?? self.movies[indexPath.row].original_title ?? self.movies[indexPath.row].name
//                let viewModel = TitlePreviewViewModel(title:title ?? "", youtubeVideo: video, description: self.movies[indexPath.row].overview ?? "")
//                
//                self.delegate?.CollectionViewTableViewCellDidTapCell(self, viewModel: self.movies[indexPath.row])
//            case .failure(let failure):
//                print(failure.localizedDescription)
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil, 
            previewProvider: nil) { _ in
                let downloadAction = UIAction(title: "Downlaod") { _ in
                    self.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", options: .displayInline, children: [downloadAction])
            }
        return config
    }
    
    
    
}
