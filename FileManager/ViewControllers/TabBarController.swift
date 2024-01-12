//
//  TabBarController.swift
//  FileManager
//
//  Created by Дмитрий Снигирев on 10.01.2024.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    let documentsViewController = DocumentsViewController()
    let settingsViewController = SettingsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let documentsNavController = UINavigationController.init(rootViewController: documentsViewController)
        documentsNavController.setupNavBar()
        
        let settingsNavController = UINavigationController.init(rootViewController: settingsViewController)
        settingsNavController.setupNavBar()
        
        documentsViewController.tabBarItem = UITabBarItem(title: "Documents", image: UIImage(systemName: "folder"), tag: 0)
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        UITabBar.appearance().tintColor = .systemBlue
        UITabBar.appearance().backgroundColor = .white
        
        setViewControllers([documentsNavController, settingsNavController], animated: true)
    }
}
