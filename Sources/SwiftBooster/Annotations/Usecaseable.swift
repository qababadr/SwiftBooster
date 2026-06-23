//
//  Usecaseable.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-09.
//

@attached(peer, names: suffixed(UseCases))
public macro Usecaseable() = #externalMacro(
    module: "SwiftBoosterMacros",
    type: "UsecaseableMacro"
)
