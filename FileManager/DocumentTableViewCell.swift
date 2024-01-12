//
//  DocumentTableViewCell.swift
//  FarManager
//
//  Created by Дмитрий Снигирев on 06.01.2024.
//

import Foundation
import UIKit

final class DocumentTableViewCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var documentTypeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemBlue
        image.image = UIImage(systemName: "photo")
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(name: String) {
        nameLabel.text = name
    }
    
    private func setupLayout() {
        [nameLabel,documentTypeImage].forEach{ contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: documentTypeImage.trailingAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            nameLabel.widthAnchor.constraint(equalToConstant: 300),
            
            documentTypeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            documentTypeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            documentTypeImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
