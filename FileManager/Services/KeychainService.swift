//
//  KeychainService.swift
//  FileManager
//
//  Created by Дмитрий Снигирев on 09.01.2024.
//

import Foundation
import KeychainAccess

final class KeychainService {
    
    static var keychain = KeychainService()
    
    var keychain = Keychain(service: "FileManager")
    var key = "password"
    
    func getPassword() -> String? {
        do {
            if let password = try keychain.get(key) {
                return password
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func savePassword(_ password: String) {
        try? keychain.set(password, key: key)
    }
    
    func updatePassword(_ password: String) {
        savePassword(password)
    }

}
