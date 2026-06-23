//
//  MainApp.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-15.
//

import SwiftBooster

@DIEntryPoint(modules: [
    ProductFeatureDomainModule.self
])
@MainActor
struct MainApp {
    init() {
        MainAppDependencies
            .shared
            .installDependencies()
    }
}
