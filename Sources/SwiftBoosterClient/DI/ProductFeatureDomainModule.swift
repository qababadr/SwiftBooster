//
//  ProductFeatureDomainModule.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-14.
//
import Swinject
import SwiftBooster
import Foundation

//this is how to define the module

@Module(feature: "ProductFeatureDomainModule")
public struct ProductFeatureDomainModule {
    
    private static func provideProductRepository(resolver: Resolver) -> ProductRepository
        {
            return ProductRepositoryImpl(
                api: resolver.resolve(ApiService.self),
                crypto: resolver.resolve(Crypto.self)
            )
        }
    
    private static func provideProductUseCases(resolver: Resolver) throws -> ProductRepositoryUseCases
        {
            guard let repository = resolver.resolve(ProductRepository.self)
            else { throw NSError(domain: "ProductRepository not found", code: 401) }
            return ProductRepositoryUseCases(repository: repository)
        }
}
