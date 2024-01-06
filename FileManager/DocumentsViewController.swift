//
//  DocumentsViewController.swift
//  FarManager
//
//  Created by Дмитрий Снигирев on 06.01.2024.
//

import UIKit

class DocumentsViewController: UIViewController {
    
    private let fileService = FileService()
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .white
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: DocumentTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.title = "Documents"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        addBarButton()
        setupLayout()
    }
    
    @objc func openImgaePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

    private func addBarButton() {
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "photo.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(openImgaePicker))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension DocumentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileService.delete(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let image = fileService.getImage(named: fileService.items[indexPath.row]) else { return }
        let showImageViewController = ShowImageViewController(imageName: fileService.items[indexPath.row], image: image)
        showImageViewController.modalPresentationStyle = .pageSheet
        showImageViewController.modalTransitionStyle = .coverVertical
        present(showImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44
    }
}

extension DocumentsViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileService.items.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.identifier, for: indexPath) as? DocumentTableViewCell else { return UITableViewCell() }
        cell.setupCell(name: fileService.items[indexPath.row])
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = .systemGray
        cell.selectedBackgroundView = selectedBackground
        cell.backgroundColor = .clear
        return cell
    }
    
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        let imageName = UUID().uuidString + ".jpeg"
        if let data = image.jpegData(compressionQuality: 1.0) {
            fileService.addFile(name: imageName, content: data)
            tableView.reloadData()
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


