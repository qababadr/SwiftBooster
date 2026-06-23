//
//  ProductRepositoryImpl.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-10.
//

import SwiftBooster

//TODO: Write a module for DI definition and do an example here for manual testing
public final class ProductRepositoryImpl: ProductRepository {
    
    private let api: ApiService?
    private let crypto: Crypto?

    public init(api: ApiService?,crypto: Crypto?) {
        self.api = api
        self.crypto = crypto
    }
    
    public func getProductsIds(page: Int) async throws -> [Int64] {
        try await Task.sleep(nanoseconds: 2_000_000)
        let start = Int64((page - 1) * 10 + 1)
        return Array(start..<(start + 10))
    }
    
    
}
