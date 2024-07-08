//
//  UpcomingTableViewCell.swift
//  NetFlix Clone
//
//  Created by Jonrel Baclayon on 7/7/24.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static let identifier = "TitleTableViewCell"
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
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
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        let posterImageConstraints = [
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            posterImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLblContraints = [
            titleLbl.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 20),
            titleLbl.trailingAnchor.constraint(lessThanOrEqualTo: playButton.leadingAnchor, constant: -10),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        let playButtonContraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(posterImageConstraints)
        NSLayoutConstraint.activate(titleLblContraints)
        NSLayoutConstraint.activate(playButtonContraints)
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: model.posterURL) else {return}
        posterImage.sd_setImage(with: url, completed: nil)
        titleLbl.text = model.titleName
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
