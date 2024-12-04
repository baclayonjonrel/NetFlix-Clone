//
//  HeroHeaderUIView.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/4/24.
//

import UIKit
import Loady

class HeroHeaderUIView: UIView {
    
    private var headerMovie: Media? = nil
    private var gradientAdded = false
    
    private let playButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "play")
        config.title = "Play"
        config.imagePadding = 10
        button.configuration = config
        
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let downloadButton: LoadyButton = {
        let button = LoadyButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 15
        button.loadingColor = .white
        button.tintColor = .white
        button.setTitle("Download", for: .normal)
        button.setImage(UIImage(systemName: "arrow.down.to.line.circle"), for: .normal)
        
        let spacing: CGFloat = 10
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)

        
        button.setAnimation(LoadyAnimationType.indicator(with: .init(indicatorViewStyle: .light)))
        button.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 30)
        label.text = "Title"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 13)
        label.text = "information"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      setupView()
    }
    
    @objc func downloadButtonClicked() {
        guard let downloadMovie = headerMovie else {return}
        if !DataPersistenceManager.shared.isMovieSaved(id: Int64(headerMovie?.id ?? 0)) {
            self.downloadButton.startLoading()
            self.downloadButton.imageView?.isHidden = true
            DataPersistenceManager.shared.downloadMovieWith(model: downloadMovie) { results in
                switch results {
                case .success(_):
                    print("saved to downloads")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.downloadButton.stopLoading()
                        self.downloadButton.imageView?.isHidden = false
                        self.downloadButton.setTitle("Downloaded", for: .normal)
                        self.downloadButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                    }
                case .failure(_):
                    print("error saving")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.downloadButton.stopLoading()
                        self.downloadButton.imageView?.isHidden = false
                        self.downloadButton.setTitle("Download", for: .normal)
                        self.downloadButton.setImage(UIImage(systemName: "arrow.down.to.line.circle"), for: .normal)
                    }
                }
            }
        }
    }
    
    @objc func playButtonClicked() {
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
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -80),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 150),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 80),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 150),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let titleLblConstraints = [
            titleLbl.bottomAnchor.constraint(equalTo: infoLbl.topAnchor, constant: -5),
            titleLbl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        let infoLblConstraints = [
            infoLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            infoLbl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        NSLayoutConstraint.activate(titleLblConstraints)
        NSLayoutConstraint.activate(infoLblConstraints)
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
            self.titleLbl.text = model.original_title ?? model.original_name ?? model.name
            self.infoLbl.text = "\(model.release_date ?? "") | \(model.vote_count) votes | \(model.vote_average) average votes"
        }

        DispatchQueue.global(qos: .background).async {
            var isSaved = false

            DispatchQueue.main.sync {
                isSaved = DataPersistenceManager.shared.isMovieSaved(id: Int64(self.headerMovie?.id ?? 0))
                if isSaved {
                    self.downloadButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                    self.downloadButton.setTitle("Downloaded", for: .normal)
                }
            }
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        addSubview(titleLbl)
        addSubview(infoLbl)
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
        if !gradientAdded {
            addGradient()
            gradientAdded = true
            setupView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
