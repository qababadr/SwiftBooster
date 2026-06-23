//
//  UsecaseableMacro.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-09.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct UsecaseableMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let protocolDecl = declaration.as(ProtocolDeclSyntax.self) else {
            return []
        }

        let protocolName = protocolDecl.name.text

        var useCases: [String] = []

        for member in protocolDecl.memberBlock.members {

            guard let function = member.decl.as(FunctionDeclSyntax.self) else {
                continue
            }

            let functionName = function.name.text

            let useCaseName =
                functionName.prefix(1).uppercased()
                + functionName.dropFirst()
                + "UseCase"

            // PARAMETERS
            let parameters = function.signature.parameterClause.parameters

            let parameterList = parameters.map { param in
                let label = param.firstName.text
                let type = param.type.trimmedDescription
                return "\(label): \(type)"
            }.joined(separator: ", ")

            let callArguments = parameters.map { param in
                let label = param.firstName.text
                return "\(label): \(label)"
            }.joined(separator: ", ")

            // RETURN TYPE
            let returnType =
                function.signature.returnClause?.type.trimmedDescription ?? "Void"

            // EFFECTS
            let isAsync = function.signature.effectSpecifiers?.asyncSpecifier != nil
            let isThrows = function.signature.effectSpecifiers?.throwsClause != nil

            let asyncKeyword = isAsync ? "async" : ""
            let throwsKeyword = isThrows ? "throws" : ""

            let signatureEffects = [asyncKeyword, throwsKeyword]
                .filter { !$0.isEmpty }
                .joined(separator: " ")

            // USE CASE (NESTED ACTOR)
            let useCase = """
            public actor \(useCaseName) {

                public let repository: \(protocolName)

                public init(repository: \(protocolName)) {
                    self.repository = repository
                }

                public func callAsFunction(
                    \(parameterList)
                ) \(signatureEffects) -> \(returnType) {

                    return try await repository.\(functionName)(
                        \(callArguments)
                    )
                }
            }
            """

            useCases.append(useCase)
        }

        let source = """
        public struct \(protocolName)UseCases {

        public let getProductsIds: GetProductsIdsUseCase

        \(useCases.joined(separator: "\n\n"))

        }
        """

        return [
            DeclSyntax(stringLiteral: source)
        ]
    }
}
