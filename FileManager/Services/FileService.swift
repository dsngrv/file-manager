//
//  FileService.swift
//  FarManager
//
//  Created by Дмитрий Снигирев on 06.01.2024.
//

import Foundation
import UIKit

final class FileService {
    
    private let directory: String
    
    var items: [String] {

        let allItems = (try? FileManager.default.contentsOfDirectory(atPath: directory)) ?? []
        
        let defaults = UserDefaults.standard
        let defaultValues = ["status": true]
        defaults.register(defaults: defaultValues)
        
        let sort = defaults.bool(forKey: "status")

        if sort {
            return allItems.sorted(by: <)
        } else {
            return allItems.sorted(by: >)
        }
    }
    
    init() {
        directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    init(directory: String) {
        self.directory = directory
    }
    
    func addFile(name: String, content: Data) {
        let url = URL(filePath: directory + "/" + name)
        try? content.write(to: url)
    }
    
    func getImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func addDirectory(name: String) {
        try? FileManager.default.createDirectory(atPath: directory + "/" + name, withIntermediateDirectories: true)
    }
    
    func getDirectoryPath(at index: Int) -> String {
        directory + "/" + items[index]
    }
    
    func delete(at index: Int) {
        let url = URL(filePath: directory + "/" + items[index])
        try? FileManager.default.removeItem(at: url)
    }
    
    func isDerictory(atIndex index: Int) -> Bool {
        let name = items[index]
        let path = directory + "/" + name
        
        var objBool: ObjCBool = false
        
        FileManager.default.fileExists(atPath: path, isDirectory: &objBool)
        
        return objBool.boolValue
    }
    
}
