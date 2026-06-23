//
//  ApiResponse.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//

public struct ApiResponse<Data: Codable & Sendable, Extra: Codable & Sendable>: Codable, Sendable {
    public let data: Data?
    public let message: String?
    public let errors: [String: [String]]?
    public let extra: Extra?
}

public struct Nothing: Codable, Sendable {}

public typealias Response<T: Codable & Sendable> = ApiResponse<T, Nothing>


