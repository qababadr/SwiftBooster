//
//  SwiftBoosterPlugin.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-09.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SwiftBoosterPlugin: CompilerPlugin {

    let providingMacros: [Macro.Type] = [
        UsecaseableMacro.self,
        ModuleMacro.self,
        DIEntryPointMacro.self,
        DataMacro.self,
        ValidateableMacro.self,
        ValidateMacro.self
    ]
}
