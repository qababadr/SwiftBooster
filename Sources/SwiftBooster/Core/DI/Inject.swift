//
//  Inject.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-10.
//

@MainActor
@propertyWrapper
public struct Inject<Service> {

    public let wrappedValue: Service

    public init() {
        guard
            let service = DIContainer
                .shared
                .resolve(Service.self)
        else {
            fatalError("Dependency of type \(Service.self) is not found!")
        }

        wrappedValue = service
    }
}
