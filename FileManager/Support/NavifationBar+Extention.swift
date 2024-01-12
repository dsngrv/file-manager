//
//  NavigationAppearance+Extention.swift
//  FarManager
//
//  Created by Дмитрий Снигирев on 06.01.2024.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        
        UIBarButtonItem.appearance().tintColor = .systemBlue
    }
    
}
