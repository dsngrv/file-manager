//
//  FileService.swift
//  FarManager
//
//  Created by Дмитрий Снигирев on 06.01.2024.
//

import Foundation
import UIKit

final class FileService {
    
    private let directrory: String
    var items: [String] {
        return (try? FileManager.default.contentsOfDirectory(atPath:directrory)) ?? []
    }
    
    init() {
        directrory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    func addFile(name: String, content: Data) {
        let url = URL(filePath: directrory + "/" + name)
        try? content.write(to: url)
    }
    
    func getImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func delete(at index: Int) {
        let url = URL(filePath: directrory + "/" + items[index])
        try? FileManager.default.removeItem(at: url)
    }
}
