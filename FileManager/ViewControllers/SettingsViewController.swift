//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Дмитрий Снигирев on 10.01.2024.
//

import Foundation
import UIKit

final class SettingsViewController: UIViewController {
    
    var isSorted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "status")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "status")
        }
    }

    weak var delegate: DocumentsViewControllerDelegate?
    
    private lazy var switcherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Sort A-Z"
        label.font = .systemFont(ofSize: 24, weight: .regular)
        return label
    }()
    
    private lazy var sortSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.onTintColor = .systemBlue
        switcher.isOn = true
        switcher.addTarget(self, action: #selector(switchDidChanged), for: .allTouchEvents)
        return switcher
    }()
    
    private lazy var changePassButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(buttonActionChangePass), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isSorted {
            sortSwitcher.isOn = true
        } else {
            sortSwitcher.isOn = false
        }
        setupLayout()
    }
    
    @objc private func switchDidChanged() {
        if sortSwitcher.isOn {
            isSorted = true
            delegate?.reload()
        } else {
            isSorted = false
            delegate?.reload()
        }
    }
    
    @objc func buttonActionChangePass() {
        let changePassViewController = StartViewController()
        changePassViewController.modalPresentationStyle = .pageSheet
        changePassViewController.modalTransitionStyle = .coverVertical
        present(changePassViewController, animated: true)
        changePassViewController.state = .editPassword
        changePassViewController.buttonState()
    }
 
    private func setupLayout() {
        view.backgroundColor = .white
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        [switcherLabel ,sortSwitcher, changePassButton].forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            switcherLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            switcherLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            
            sortSwitcher.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            sortSwitcher.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            
            changePassButton.topAnchor.constraint(equalTo: switcherLabel.bottomAnchor, constant: 16),
            changePassButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            changePassButton.heightAnchor.constraint(equalToConstant: 32),
            changePassButton.widthAnchor.constraint(equalToConstant: 256)
        ])
    }
}
