//
//  Data.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-15.
//

@attached(member, names: named(copy), named(init))
public macro Data(
    generateCopy: Bool = true,
    generateOptionalInit: Bool = true
) = #externalMacro(
    module: "SwiftBoosterMacros",
    type: "DataMacro"
)
