//
//  Module.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-10.
//

@attached(
    member,
    names: named(init),
    named(install)
)
public macro Module(
    feature: String
) = #externalMacro(
    module: "SwiftBoosterMacros",
    type: "ModuleMacro"
)
