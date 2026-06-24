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

        guard let protocolDecl = declaration.as(ProtocolDeclSyntax.self)
        else {
            return []
        }

        let protocolName = protocolDecl.name.text

        var useCases: [String] = []
        var properties: [String] = []
        var initializers: [String] = []

        for member in protocolDecl.memberBlock.members {

            guard let function = member.decl.as(FunctionDeclSyntax.self)
            else {
                continue
            }

            let functionName = function.name.text

            let useCaseName =
                functionName.prefix(1).uppercased()
                + functionName.dropFirst()
                + "UseCase"

            properties.append(
                "public let \(functionName): \(useCaseName)"
            )

            initializers.append(
                "self.\(functionName) = \(useCaseName)(repository: repository)"
            )

            // MARK: - Parameters

            let parameters = function
                .signature
                .parameterClause
                .parameters

            let parameterList = parameters.map { param in

                let label = param.firstName.text
                let type = param.type.trimmedDescription

                return "\(label): \(type)"
            }
            .joined(separator: ", ")

            let callArguments = parameters.map { param in

                let label = param.firstName.text

                return "\(label): \(label)"
            }
            .joined(separator: ", ")

            // MARK: - Return Type

            let returnType =
                function.signature.returnClause?.type.trimmedDescription
                ?? "Void"

            // MARK: - Effects

            let isAsync =
                function.signature.effectSpecifiers?.asyncSpecifier != nil

            let isThrows =
                function.signature.effectSpecifiers?.throwsClause != nil

            let asyncKeyword = isAsync ? "async" : ""
            let throwsKeyword = isThrows ? "throws" : ""

            let signatureEffects = [
                asyncKeyword,
                throwsKeyword
            ]
            .filter { !$0.isEmpty }
            .joined(separator: " ")

            // MARK: - Repository Call

            let repositoryCall: String

            switch (isAsync, isThrows) {

            case (true, true):
                repositoryCall =
                "try await repository.\(functionName)(\(callArguments))"

            case (true, false):
                repositoryCall =
                "await repository.\(functionName)(\(callArguments))"

            case (false, true):
                repositoryCall =
                "try repository.\(functionName)(\(callArguments))"

            case (false, false):
                repositoryCall =
                "repository.\(functionName)(\(callArguments))"
            }

            let body: String

            if returnType == "Void" {

                body = repositoryCall

            } else {

                body = "return \(repositoryCall)"
            }

            // MARK: - Use Case

            let useCase = """
            public actor \(useCaseName) {

                public let repository: \(protocolName)

                public init(
                    repository: \(protocolName)
                ) {
                    self.repository = repository
                }

                public func callAsFunction(
                    \(parameterList)
                ) \(signatureEffects) -> \(returnType) {

                    \(body)
                }
            }
            """

            useCases.append(useCase)
        }

        let source = """
        public actor \(protocolName)UseCases {

        \(properties.joined(separator: "\n"))

        public init(
            repository: \(protocolName)
        ) {

        \(initializers.joined(separator: "\n"))
        }

        \(useCases.joined(separator: "\n\n"))

        }
        """

        return [
            DeclSyntax(
                stringLiteral: source
            )
        ]
    }
}
