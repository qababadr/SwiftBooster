//
//  Crypto.swift
//  CoreApp
//
//  Created by BADR  QABA on 2026-02-10.
//

public protocol Crypto: Sendable {

    /// Saves the given API token securely to the Keychain.
    ///
    /// - Parameter token: The API token string to be saved.
    func saveToken(token: String)

    /// Loads the API token from the Keychain, if it exists.
    ///
    /// - Returns: The token string if found; otherwise, `nil`.
    func loadToken() -> String?
    
    func deleteToken()
}
