//
//  Reusable.swift
//  FarManager
//
//  Created by Дмитрий Снигирев on 06.01.2024.
//

import Foundation
import UIKit

protocol Reusable: AnyObject {
    static var identifier: String { get }
}

extension UITableViewCell: Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}
