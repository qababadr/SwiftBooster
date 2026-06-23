//
//  Validate.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-15.
//

@attached(peer, names: arbitrary)
public macro Validate(_ rule: ValidationRule) = #externalMacro(
    module: "SwiftBoosterMacros",
    type: "ValidateMacro"
)
