//
//  UpcomingTableViewCell.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/7/24.
//

import UIKit

protocol DownloadViewControllerDelegate: AnyObject {
    func deleteMovie(movie: Media)
}

class TitleTableViewCell: UITableViewCell {
    
    weak var delegate: DownloadViewControllerDelegate?
    
    static let identifier = "TitleTableViewCell"
    var hideDelete = false
    private var selectedMovie: Media?
    private var playButtonTrailingConstraint: NSLayoutConstraint?
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let posterImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 5
        return image
    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImage)
        contentView.addSubview(titleLbl)
        contentView.addSubview(playButton)
        contentView.addSubview(deleteButton)
        
        applyConstraints(hideDelete: hideDelete)
    }
    
    private func applyConstraints(hideDelete: Bool) {
        let posterImageConstraints = [
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            posterImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLblContraints = [
            titleLbl.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            titleLbl.trailingAnchor.constraint(lessThanOrEqualTo: playButton.leadingAnchor, constant: 5),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        let playButtonContraints = [
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 40)
        ]
        
        let deleteButtonsConstraints = [
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(posterImageConstraints)
        NSLayoutConstraint.activate(titleLblContraints)
        NSLayoutConstraint.activate(playButtonContraints)
        NSLayoutConstraint.activate(deleteButtonsConstraints)
        if playButtonTrailingConstraint == nil {
            playButtonTrailingConstraint = playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -70)
            playButtonTrailingConstraint?.isActive = true
        }
    }
    
    public func configure(with model: Media, hideDelete: Bool) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.poster_path ?? "")") else {return}
        selectedMovie = model
        self.updateDeleteButtonVisibility(isHidden: hideDelete)
        posterImage.sd_setImage(with: url, completed: nil)
        titleLbl.text = model.original_title ?? model.original_name ?? model.name
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func updateDeleteButtonVisibility(isHidden: Bool) {
        playButtonTrailingConstraint?.isActive = false
        
        if !isHidden {
            deleteButton.isHidden = true
            playButtonTrailingConstraint = playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        } else {
            deleteButton.isHidden = false
            playButtonTrailingConstraint = playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -70)
        }
        
        playButtonTrailingConstraint?.isActive = true
        
        contentView.layoutIfNeeded()
    }
    
    @objc func deleteButtonClicked() {
        print("delete button clicked")
        if let movie = selectedMovie {
            self.delegate?.deleteMovie(movie: movie)
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
}
