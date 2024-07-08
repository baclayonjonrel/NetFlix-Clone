//
//  DetailViewController.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/7/24.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(heroImageView)
        view.addSubview(playButton)
        view.addSubview(downloadButton)
        view.backgroundColor = .systemBackground
        activateConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    public func configure(with model: Media) {
        let placeholderImage = UIImage(named: "placeholder")

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.poster_path ?? "")") else {
            heroImageView.image = placeholderImage
            return
        }
        heroImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
    }
    
    private func activateConstraints() {
        let heroImageViewConstraints = [
            heroImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heroImageView.topAnchor.constraint(equalTo: view.topAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.6)
        ]
        
        let playButtonConstraints = [
            playButton.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant:30),
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 10),
            downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            downloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(heroImageViewConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }

}
