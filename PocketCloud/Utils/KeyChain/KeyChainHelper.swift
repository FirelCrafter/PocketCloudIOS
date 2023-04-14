//
//  KeyChainHelper.swift
//  PocketCloud
//
//  Created by Михаил Щербаков on 14.04.2023.
//

import SwiftUI

/// Class stores data in KeyChain

class KeyChainHelper {
    
    static let shared = KeyChainHelper()
    
    func save(data: Data, key: String, account: String) {
        
        let query = [
            kSecValueData: data,
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        switch status {
        case errSecSuccess: print("Success")
            
        case errSecDuplicateItem:
            let updateQuery = [
                kSecAttrAccount: account,
                kSecAttrService: key,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            
            let updateAttr = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(updateQuery, updateAttr)
            
        default: print("Error \(status)")
        }
    }
    
    func read(key: String, account: String) -> Data? {
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var resultData: AnyObject?
        SecItemCopyMatching(query, &resultData)
        
        return (resultData as? Data)
    }
    
    func delete(key: String, account: String) {
        let query = [
            kSecAttrAccount: account,
            kSecAttrService: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}
