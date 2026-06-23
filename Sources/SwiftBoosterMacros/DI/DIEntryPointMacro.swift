//
//  DIEntryPointMacro.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-15.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DIEntryPointMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let appStruct =
            declaration.as(StructDeclSyntax.self)
        else {
            return []
        }

        let appName = appStruct.name.text

        guard let arguments =
            node.arguments?.as(LabeledExprListSyntax.self)
        else {
            return []
        }

        guard let modulesArgument = arguments.first(
            where: { $0.label?.text == "modules" }
        )
        else {
            return []
        }

        guard let arrayExpr =
            modulesArgument.expression.as(ArrayExprSyntax.self)
        else {
            return []
        }

        var installStatements: [String] = []

        for element in arrayExpr.elements {

            guard let memberAccess =
                element.expression.as(MemberAccessExprSyntax.self)
            else {
                continue
            }

            guard let base = memberAccess.base
            else {
                continue
            }

            let moduleName = base.trimmedDescription

            installStatements.append(
                "\(moduleName).install()"
            )
        }

        let dependencyClassName =
            "\(appName)Dependencies"

        let source = """
        public final class \(dependencyClassName): Sendable {

            public static let shared = \(dependencyClassName)()

            private init() {}

            @MainActor
            public func installDependencies() {

        \(installStatements.map { "        \($0)" }.joined(separator: "\n"))

            }
        }
        """

        return [
            DeclSyntax(stringLiteral: source)
        ]
    }
}
