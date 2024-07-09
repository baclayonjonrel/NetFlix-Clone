//
//  DetailViewController.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/7/24.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
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
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 25)
        label.text = "Title"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 8)
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
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
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
        heroImageView.addBlackGradientLayerInForeground(frame: self.view.bounds, colors:[.clear, .black])
        
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

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.poster_path ?? "")") else {
            heroImageView.image = placeholderImage
            return
        }
        heroImageView.sd_setImage(with: url, placeholderImage: placeholderImage)
        
        titleLbl.text = model.original_title ?? model.original_name ?? model.name
        infoLbl.text = "\(model.release_date ?? "") | \(model.vote_count) votes | \(model.vote_average) average votes"
        descriptionLbl.text = model.overview
        
        checkDescriptionHeight()
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
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -20),
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
            heroImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.50),
            
            titleLbl.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: -10),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            infoLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 5),
            infoLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            playButton.topAnchor.constraint(equalTo: infoLbl.bottomAnchor, constant: 10),
            playButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -5),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            
            downloadButton.topAnchor.constraint(equalTo: infoLbl.bottomAnchor, constant: 10),
            downloadButton.leadingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 5),
            downloadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionLbl.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 10),
            descriptionLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            seeMoreButton.topAnchor.constraint(equalTo: descriptionLbl.bottomAnchor, constant: 5),
            seeMoreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            seeMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

extension UIView {
    // For insert layer in Foreground
    func addBlackGradientLayerInForeground(frame: CGRect, colors: [UIColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map { $0.cgColor }
        self.layer.addSublayer(gradient)
    }
    
    // For insert layer in background
    func addBlackGradientLayerInBackground(frame: CGRect, colors: [UIColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map { $0.cgColor }
        self.layer.insertSublayer(gradient, at: 0)
    }
}
