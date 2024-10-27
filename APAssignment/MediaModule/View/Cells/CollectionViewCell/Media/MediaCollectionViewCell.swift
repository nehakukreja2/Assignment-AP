//
//  MediaCollectionViewCell.swift
//  APAssignment
//
//  Created by Neha Kukreja on 22/10/24.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var publishedBy: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var representedIdentifier: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayouts()
        setupActivityIndicator()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaImage.image = nil
    }
    
    func setupLayouts() {
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor(red: 30/255, green: 0/255, blue: 42/255, alpha: 1.0).cgColor
        mediaImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mediaImage.layer.cornerRadius = 10
        mediaImage.clipsToBounds = true
    }
    
    func setupActivityIndicator() {
        contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: mediaImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: mediaImage.centerYAnchor)
        ])
    }
    
    func configure(with data: Medias, representedIdentifier: String) {
        titleLabel.text = data.title
        publishedBy.text = data.publishedBy
        
        let placeholderImage = UIImage(named: "noImageAvailable")
        activityIndicator.startAnimating()
        
        if let imageURL = data.thumbnailURL() {
            
            ImageLoader.shared.loadImage(from: imageURL) { [weak self] image in
                guard let self = self else { return }
                if self.representedIdentifier == representedIdentifier {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.activityIndicator.stopAnimating()
                        if let loadedImage = image, self.representedIdentifier == representedIdentifier {
                            UIView.transition(with: self.mediaImage, duration: 0.3, options: .transitionCrossDissolve, animations: {
                                self.mediaImage.image = loadedImage
                            }, completion: nil)
                        } else {
                            self.mediaImage.image = placeholderImage
                        }
                    }
                }
            }
        }else {
            activityIndicator.stopAnimating()
            mediaImage.image = placeholderImage
        }
    }
}
