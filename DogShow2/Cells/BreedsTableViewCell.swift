//
//  BreedsTableViewCell.swift
//  DogShow2
//
//  Created by Surgeont on 07.11.2021.
//

import UIKit

final class BreedsTableViewCell: UITableViewCell {
    
    private let breedNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder")
    }
    
    func setConstraints() {
        self.addSubview(breedNameLabel)
        NSLayoutConstraint.activate([
            breedNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            breedNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            breedNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }

    override func prepareForReuse() {
        self.breedNameLabel.text = nil
    }
    
     func setupCell(breed: String) {
        self.breedNameLabel.text = breed
        breedNameLabel.font = .systemFont(ofSize: 20)
         self.selectionStyle = .none
    }
}
