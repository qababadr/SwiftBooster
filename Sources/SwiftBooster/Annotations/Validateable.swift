//
//  Validateable.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-15.
//

@attached(member, names: named(isValidForm))
public macro Validateable() = #externalMacro(
    module: "SwiftBoosterMacros",
    type: "ValidateableMacro"
)
