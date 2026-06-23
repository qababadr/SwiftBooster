//
//  DIContainer.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-10.
//

import Swinject

@MainActor
public final class DIContainer {

    public static let shared: DIContainer = DIContainer()

    private let container: Container = Container()

    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        container.resolve(serviceType)
    }

    public func register<Service>(
        scope: ObjectScope = .container,
        _ serviceType: Service.Type,
        factory: @escaping (Resolver) -> Service
    ) {
        container
            .register(serviceType) { resolver in factory(resolver) }
            .inObjectScope(scope)
    }

    private init() {}
}
