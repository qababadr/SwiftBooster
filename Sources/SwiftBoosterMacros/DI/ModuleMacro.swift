//
//  ModuleMacro.swift
//  SwiftBooster
//
//  Created by BADR QABA on 2026-06-10.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ModuleMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let structDecl = declaration.as(StructDeclSyntax.self)
        else {
            return []
        }

        let moduleName = structDecl.name.text

        var registrations: [String] = []

        for member in structDecl.memberBlock.members {

            guard let function =
                member.decl.as(FunctionDeclSyntax.self)
            else {
                continue
            }

            let functionName = function.name.text

            guard functionName.hasPrefix("provide")
            else {
                continue
            }

            guard let returnType =
                function.signature
                    .returnClause?
                    .type
                    .trimmedDescription
            else {
                continue
            }

            let isThrows =
                function.signature.effectSpecifiers?.throwsClause != nil

            let providerCall: String

            if isThrows {

                providerCall = """
                try! \(moduleName).\(functionName)(resolver: $0)
                """

            } else {

                providerCall = """
                \(moduleName).\(functionName)(resolver: $0)
                """
            }

            let registration = """
            DIContainer
                .shared
                .register(\(returnType).self) {
                    \(providerCall)
                }
            """

            registrations.append(registration)
        }

        let initDecl = """
        private init() {}
        """

        let installDecl = """
        @MainActor
        public static func install() {

        \(registrations.joined(separator: "\n\n"))

        }
        """

        return [
            DeclSyntax(stringLiteral: initDecl),
            DeclSyntax(stringLiteral: installDecl)
        ]
    }
}
