//
//  DetailViewController.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/7/24.
//

import UIKit
import WebKit
import Loady

class DetailViewController: UIViewController {
    
    private var movie: Media? = nil
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
    
    private let descriptionLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 15)
        label.text = "description"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See More", for: .normal)
        button.addTarget(self, action: #selector(didTapSeeMore), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
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
        
        let spacing: CGFloat = 10
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)

        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 15
        button.loadingColor = .white
        button.tintColor = .white
        button.setTitle("Download", for: .normal)
        button.setImage(UIImage(systemName: "arrow.down.to.line.circle"), for: .normal)
        button.setAnimation(LoadyAnimationType.indicator(with: .init(indicatorViewStyle: .light)))
        button.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var isExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      setupView()
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(heroImageView)
        contentView.addSubview(titleLbl)
        contentView.addSubview(infoLbl)
        contentView.addSubview(descriptionLbl)
        contentView.addSubview(seeMoreButton)
        contentView.addSubview(playButton)
        contentView.addSubview(downloadButton)
        view.backgroundColor = .systemBackground
        activateConstraints()
        
        addBlackGradientToImageView(heroImageView)
    }
    
    private func checkIfSaved(model: Media) {
        let isSaved  = DataPersistenceManager.shared.isMovieSaved(id: Int64(model.id))
        if isSaved {
            self.downloadButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            self.downloadButton.setTitle("Downloaded", for: .normal)
            self.downloadButton.tintColor = .white
            self.downloadButton.imageView?.tintColor = .white
        }
        
    }
    
    private func addBlackGradientToImageView(_ imageView: UIImageView) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.75)

        gradient.contentsScale = UIScreen.main.scale
        gradient.contentsGravity = .resizeAspectFill

        imageView.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc func downloadButtonClicked() {
        guard let downloadMovie = movie else {return}
        if !DataPersistenceManager.shared.isMovieSaved(id: Int64(downloadMovie.id)) {
            self.downloadButton.startLoading()
            self.downloadButton.imageView?.isHidden = true
            DataPersistenceManager.shared.downloadMovieWith(model: downloadMovie) { results in
                switch results {
                case .success(_):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.downloadButton.stopLoading()
                        self.downloadButton.setTitle("Downloaded", for: .normal)
                        self.downloadButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                        self.downloadButton.imageView?.isHidden = false
                    }
                case .failure(_):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.downloadButton.stopLoading()
                        self.downloadButton.setTitle("Download", for: .normal)
                        self.downloadButton.setImage(UIImage(systemName: "arrow.down.to.line.circle"), for: .normal)
                        self.downloadButton.imageView?.isHidden = false
                    }
                }
            }
        }
    }
    
    @objc func playButtonClicked() {
        VideoPlayerViewController.shared.playSampleVideo(from: self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        checkDescriptionHeight()
    }
    
    @objc private func didTapSeeMore() {
        isExpanded.toggle()
        descriptionLbl.numberOfLines = isExpanded ? 0 : 3
        seeMoreButton.setTitle(isExpanded ? "See Less" : "See More", for: .normal)
    }
    
    public func configure(with model: Media) {
        let placeholderImage = UIImage(named: "placeholder")
        movie = model
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.poster_path ?? "")") else {
            heroImageView.image = placeholderImage
            return
        }
        heroImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        
        titleLbl.text = model.original_title ?? model.original_name ?? model.name
        infoLbl.text = "\(model.release_date ?? "") | \(model.vote_count) votes | \(model.vote_average) average votes"
        descriptionLbl.text = model.overview
        
        if DataPersistenceManager.shared.isMovieSaved(id: Int64(model.id)) {
            downloadButton.isEnabled = false
            downloadButton.backgroundColor = .lightGray
            downloadButton.setTitle("Saved", for: .normal)
        }
        
        checkDescriptionHeight()
        checkIfSaved(model: model)
    }
    
    private func checkDescriptionHeight() {
        let text = descriptionLbl.text ?? ""
        let width = descriptionLbl.frame.width
        let font = descriptionLbl.font!
        
        if isTextExceedingLines(text: text, font: font, width: width, maxLines: 3) {
            seeMoreButton.isHidden = false
        } else {
            seeMoreButton.isHidden = true
        }
    }
    
    private func isTextExceedingLines(text: String, font: UIFont, width: CGFloat, maxLines: Int) -> Bool {
        let maxLinesHeight = CGFloat(maxLines) * font.lineHeight
        let textHeight = text.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).height
        return textHeight > maxLinesHeight
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.45),
            
            titleLbl.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -55),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            infoLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 5),
            infoLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            playButton.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 130),
            playButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            playButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -5),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            
            downloadButton.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 130),
            downloadButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 5),
            downloadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            downloadButton.heightAnchor.constraint(equalToConstant: 50),
            
            descriptionLbl.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 20),
            descriptionLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            seeMoreButton.topAnchor.constraint(equalTo: descriptionLbl.bottomAnchor, constant: 5),
            seeMoreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            seeMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

