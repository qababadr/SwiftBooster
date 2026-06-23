//
//  DefaultCrypto.swift
//  CoreApp
//
//  Created by BADR  QABA on 2026-02-10.
//
import Foundation

public final class DefaultCrypto: Crypto {
    
    public init() {}

    // The Keychain service name, used to uniquely identify your app's stored items
    private let service = "com.badrqaba.defaultCrypto"

    // The account key used to identify the specific Keychain entry
    private let account = "defaultCryptoAuthToken"

    // Saves the given token securely to the Keychain
    public func saveToken(token: String) {
        // Convert the string token to `Data` using UTF-8 encoding
        guard let tokenData = token.data(using: .utf8) else { return }

        // Create the query dictionary required by the Keychain API
        // - `kSecClass`: defines the kind of Keychain item (generic password in this case)
        // - `kSecAttrService`: identifies your app/service uniquely
        // - `kSecAttrAccount`: defines the user or item key (e.g., apiToken)
        // - `kSecValueData`: the actual data to store (the token)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: tokenData
        ]

        // Delete any existing Keychain item with the same service/account before adding a new one
        SecItemDelete(query as CFDictionary)

        // Add the new token item to the Keychain the result status (0 means success)
        SecItemAdd(query as CFDictionary, nil)
    }

    // Loads and returns the token stored in the Keychain (if any)
    public func loadToken() -> String? {
        // Build the query to look for the Keychain item
        // - `kSecClass`: generic password item
        // - `kSecAttrService`: must match the service you used to store
        // - `kSecAttrAccount`: must match the account used to store
        // - `kSecReturnData`: request the actual token data to be returned
        // - `kSecMatchLimit`: only return one result
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        // Variable to store the result of the Keychain search
        var result: AnyObject?

        // Try to find the token in the Keychain
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        // If the status is success, try to convert the data back into a String
        if status == errSecSuccess,
           let data = result as? Data,
           let token = String(data: data, encoding: .utf8) {
            // Return the decoded token string
            return token
        }

        // If retrieval failed or data is missing/corrupt, return nil
        return nil
    }
    
    public func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }

}
