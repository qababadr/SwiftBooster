//
//  DIEntryPoint.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-15.
//

@attached(
    peer,
    names: suffixed(Dependencies)
)
public macro DIEntryPoint(
    modules: [Any.Type]
) = #externalMacro(
    module: "SwiftBoosterMacros",
    type: "DIEntryPointMacro"
)
