//
//  DocumentsViewController.swift
//  FarManager
//
//  Created by Дмитрий Снигирев on 06.01.2024.
//

import UIKit

protocol DocumentsViewControllerDelegate: AnyObject {
    func reload()
}

final class DocumentsViewController: UIViewController {
    
    private let fileService: FileService
        
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

    init() {
        fileService = FileService()
        super.init(nibName: nil, bundle: nil)
    }
    
    init(fileService: FileService) {
        self.fileService = fileService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    @objc func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc func addFolder() {
        let alert = UIAlertController(title: "Enter folder name", message: nil, preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "Folder name"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            let name = alert.textFields?[0].text
            self?.fileService.addDirectory(name: name ?? " ")
            self?.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    private func addPhotoBarButton() -> UIBarButtonItem {
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "photo.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(openImagePicker))
        return addButton
    }
    
    private func addFolderBarButton() -> UIBarButtonItem {
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "folder.badge.plus"),
            style: .plain,
            target: self,
            action: #selector(addFolder))
        return addButton
    }
    
    private func showAlert(image: UIImage) {
        let alert = UIAlertController(title: "Enter file name", message: nil, preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "File name"
        }
        
        let okAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            guard let self = self,
                  let imageName = alert.textFields?[0].text,
                  !imageName.isEmpty,
                  let data = image.pngData()
            else { return }
            fileService.addFile(name: imageName + ".jpeg", content: data)
            tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        navigationItem.title = "Documents"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItems = [addPhotoBarButton(), addFolderBarButton()]
        
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
        if !fileService.isDerictory(atIndex: indexPath.row) {
            guard let image = fileService.getImage(named: fileService.items[indexPath.row]) else { return }
            let showImageViewController = ShowImageViewController(imageName: fileService.items[indexPath.row], image: image)
            showImageViewController.modalPresentationStyle = .pageSheet
            showImageViewController.modalTransitionStyle = .coverVertical
            present(showImageViewController, animated: true)
        } else {
            let path = fileService.getDirectoryPath(at: indexPath.row)
            let fileService = FileService(directory: path)
            let nextDocumentsViewController = DocumentsViewController(fileService: fileService)
            navigationController?.pushViewController(nextDocumentsViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DocumentsViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fileService.items.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DocumentTableViewCell.identifier, for: indexPath) as? DocumentTableViewCell else { return UITableViewCell() }
        
        let image = fileService.getImage(named: fileService.items[indexPath.row])
        if !fileService.isDerictory(atIndex: indexPath.row) {
            cell.setupCell(name: fileService.items[indexPath.row], type: "File", image: image!)
            let selectedBackground = UIView()
            selectedBackground.backgroundColor = .systemGray
            cell.selectedBackgroundView = selectedBackground
            cell.backgroundColor = .clear
        } else {
            cell.setupCell(name: fileService.items[indexPath.row], type: "Folder", image: UIImage(systemName: "folder")!)
            let selectedBackground = UIView()
            selectedBackground.backgroundColor = .systemGray
            cell.selectedBackgroundView = selectedBackground
            cell.backgroundColor = .clear
        }
        return cell
    }
    
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true)

        showAlert(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension DocumentsViewController: DocumentsViewControllerDelegate {
    func reload() {
        tableView.reloadData()
    }
}
