//
//  DataMacro.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-15.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

fileprivate struct Property {
    let name: String
    let type: String
    let defaultValue: String?
}

public struct DataMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            return []
        }

        let structName = structDecl.name.text

        let generateCopy = boolArgument(
            named: "generateCopy",
            from: node,
            defaultValue: true
        )

        let generateInit = boolArgument(
            named: "generateOptionalInit",
            from: node,
            defaultValue: true
        )

        let alreadyHasInit = structDecl.memberBlock.members.contains {
            $0.decl.is(InitializerDeclSyntax.self)
        }

        var properties: [Property] = []

        for member in structDecl.memberBlock.members {

            guard let variable =
                member.decl.as(VariableDeclSyntax.self)
            else {
                continue
            }

            guard
                let binding = variable.bindings.first,
                let identifierPattern =
                    binding.pattern.as(IdentifierPatternSyntax.self),
                let typeAnnotation = binding.typeAnnotation
            else {
                continue
            }

            properties.append(
                Property(
                    name: identifierPattern.identifier.text,
                    type: typeAnnotation.type.trimmedDescription,
                    defaultValue: binding.initializer?.value.trimmedDescription
                )
            )
        }

        var generatedMembers: [DeclSyntax] = []

        // MARK: - INIT

        if generateInit && !alreadyHasInit {

            let initParameters = properties.map { property in

                if let defaultValue = property.defaultValue {
                    return "\(property.name): \(property.type) = \(defaultValue)"
                }

                return "\(property.name): \(property.type)"
            }
            .joined(separator: ",\n        ")

            let initAssignments = properties.map {
                "self.\($0.name) = \($0.name)"
            }
            .joined(separator: "\n        ")

            let initSource = """
            public init(
                \(initParameters)
            ) {
                \(initAssignments)
            }
            """

            generatedMembers.append(
                DeclSyntax(stringLiteral: initSource)
            )
        }

        // MARK: - COPY

        if generateCopy {

            let copyParameters = properties.map {
                "\($0.name): \($0.type)? = nil"
            }
            .joined(separator: ",\n        ")

            let copyAssignments = properties.map {
                "\($0.name): \($0.name) ?? self.\($0.name)"
            }
            .joined(separator: ",\n                ")

            let copySource = """
            public func copy(
                \(copyParameters)
            ) -> \(structName) {

                return \(structName)(
                    \(copyAssignments)
                )
            }
            """

            generatedMembers.append(
                DeclSyntax(stringLiteral: copySource)
            )
        }

        return generatedMembers
    }

    private static func boolArgument(
        named name: String,
        from node: AttributeSyntax,
        defaultValue: Bool
    ) -> Bool {

        guard
            let arguments =
                node.arguments?.as(LabeledExprListSyntax.self),
            let argument =
                arguments.first(where: {
                    $0.label?.text == name
                })
        else {
            return defaultValue
        }

        let value = argument.expression.trimmedDescription

        return value == "true"
    }
}
