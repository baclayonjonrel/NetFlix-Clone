//
//  HeroHeaderUIView.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/4/24.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    private var headerMovie: Media? = nil
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonClicked), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroimage")
        return imageView
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    @objc func downloadButtonClicked() {
        print("download button clicked")
        guard let downloadMovie = headerMovie else {return}
        if !DataPersistenceManager.shared.isMovieSaved(id: Int64(headerMovie?.id ?? 0)) {
            self.downloadButton.setTitle("Downloading...", for: .normal)
            DataPersistenceManager.shared.downloadMovieWith(model: downloadMovie) { results in
                switch results {
                case .success(let success):
                    print("saved to downloads")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.downloadButton.setTitle("Downloaded", for: .normal)
                        self.downloadButton.backgroundColor = .lightGray
                        //self.downloadButton.isEnabled = false
                    }
                case .failure(let failure):
                    print("error saving")
                }
            }
        }
    }
    
    @objc func playButtonClicked() {
        print("play button clicked")
        var responder: UIResponder? = self.next
        while responder != nil {
            if let viewController = responder as? UIViewController {
                VideoPlayerViewController.shared.playSampleVideo(from: viewController)
                break
            }
            responder = responder?.next
        }
    }
    
    private func applyConstraints() {
        let playButtonConstraints = [
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    public func configure(with model: Media) {
        headerMovie = model
        let placeholderImage = UIImage(named: "placeholder")

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.poster_path ?? "")") else {
            heroImageView.image = placeholderImage
            return
        }
        
        DispatchQueue.main.async {
            self.heroImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        }

        DispatchQueue.global(qos: .background).async {
            var isSaved = false

            DispatchQueue.main.sync {
                isSaved = DataPersistenceManager.shared.isMovieSaved(id: Int64(self.headerMovie?.id ?? 0))
            }
            
            DispatchQueue.main.async {
                if isSaved {
                    self.downloadButton.setTitle("Downloaded", for: .normal)
                    self.downloadButton.backgroundColor = .lightGray
                    //self.downloadButton.isEnabled = false
                }
            }
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
