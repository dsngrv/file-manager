//
//  StartViewController.swift
//  FileManager
//
//  Created by Дмитрий Снигирев on 09.01.2024.
//

import Foundation
import UIKit

final class StartViewController: UIViewController {
    
    var keyChain = KeychainService.keychain
    var state = State.logIn
    var pass: String = ""
    
    private lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerState()
        buttonState()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func buttonAction() {
        switch state {
        case .logIn:
            guard let pass = keyChain.getPassword() else { return }
            if passwordField.text == pass {
                let tabBarController = TabBarController()
                self.navigationController?.pushViewController(tabBarController, animated: true)
            } else {
                showPassAlert(text: "Wrong password")
                passwordField.text = ""
            }
        case .signUp:
            guard passwordField.text!.count >= 4, !passwordField.text!.isEmpty else {
                showPassAlert(text: "The password must contain a minimum of 4 characters")
                passwordField.text = ""
                return
            }
            if pass == "" {
                pass = passwordField.text!
                passwordField.text! = ""
                showPassAlert(text: "Repeat password")
            } else {
                if passwordField.text! == pass {
                    keyChain.savePassword(passwordField.text!)
                    print(passwordField.text!)
                    let tabBarController = TabBarController()
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                } else {
                    showPassAlert(text: "The passwords don't match")
                    passwordField.text! = ""
                }
            }
        case .editPassword:
            button.setTitle("Change password", for: .normal)
            print("passedit")
            guard passwordField.text!.count >= 4, !passwordField.text!.isEmpty else {
                showPassAlert(text: "The password must contain a minimum of 4 characters")
                passwordField.text = ""
                return
            }
            keyChain.updatePassword(passwordField.text!)
            showPassAlert(text: "Password was changed to \(passwordField.text!)")
        }
    }
    
    private func viewControllerState() {
        if (keyChain.getPassword() != nil) {
            state = .logIn
        } else {
            state = .signUp
        }
    }
    
    func buttonState() {
        switch state {
        case .logIn:
            button.setTitle("Log In", for: .normal)
        case .signUp:
            button.setTitle("Sign Up", for: .normal)
        case .editPassword:
            button.setTitle("Change password", for: .normal)
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemGray
        [passwordField, button].forEach({view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            passwordField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -8),
            passwordField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 32),
            passwordField.widthAnchor.constraint(equalToConstant: 256),
            
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 8),
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 32),
            button.widthAnchor.constraint(equalToConstant: 256),
        ])
    }
    
}


private extension UIViewController {
    func showPassAlert(text: String) {
        let alertPass = UIAlertController(title: "Password", message: text, preferredStyle: .alert)
        alertPass.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alertPass, animated: true)
    }
}
