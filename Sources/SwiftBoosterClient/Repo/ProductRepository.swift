//
//  ProductRepository.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-09.
//
import SwiftBooster

@Usecaseable
public protocol ProductRepository: Sendable {

    func getProductsIds(
        page: Int
    ) async throws -> [Int64]
}
