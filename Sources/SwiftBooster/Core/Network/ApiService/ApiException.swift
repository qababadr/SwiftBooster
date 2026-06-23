//
//  ApiError.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import Foundation

public struct ApiException: Error, Codable {
    public let message: String
    public let errors: [String: [String]]?
    public let statusCode: Int?

    public init(
        message: String,
        errors: [String: [String]]? = nil,
        statusCode: Int? = nil
    ) {
        self.message = message
        self.errors = errors
        self.statusCode = statusCode
    }
}
