//
//  DogImagesCollectionViewCell.swift
//  DogShow2
//
//  Created by Surgeont on 08.11.2021.
//

import UIKit

final class DogImagesCollectionViewCell: UICollectionViewCell {
    
    private let dogImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loadManager = LoadAndCashImages.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dogImage.image = .none
    }
    
    func setupCell(url: String) {
        guard let urlForImage = URL(string: url) else { return }
        loadManager.downloadImage(url: urlForImage) { image in
            self.dogImage.image = image
        }
    }
    
    func setConstraints() {
        self.addSubview(dogImage)
        NSLayoutConstraint.activate([
            dogImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            dogImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            dogImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            dogImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
    }
}
