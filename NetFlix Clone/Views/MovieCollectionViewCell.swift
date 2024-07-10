//
//  MovieCollectionViewCell.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/7/24.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with moviePoster: String) {
        let placeholderImage = UIImage(named: "placeholder")

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(moviePoster)") else {
            posterImageView.image = placeholderImage
            return
        }
        posterImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
    }
}
