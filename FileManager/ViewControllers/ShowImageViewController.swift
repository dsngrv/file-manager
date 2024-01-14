//
//  ShowImageViewController.swift
//  FarManager
//
//  Created by Дмитрий Снигирев on 06.01.2024.
//

import Foundation
import UIKit

final class ShowImageViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var imageNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    init(imageName: String, image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = image
        self.imageNameLabel.text = imageName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        setupLayout()
    }
    
    func setupLayout() {
        [imageView, imageNameLabel].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            imageView.bottomAnchor.constraint(equalTo: imageNameLabel.topAnchor),
            
            imageNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            imageNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            imageNameLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            imageNameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
