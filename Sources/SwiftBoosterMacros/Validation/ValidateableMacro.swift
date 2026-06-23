//
//  ValidateableMacro.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-15.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ValidateableMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            return []
        }

        var validations: [String] = []

        for member in structDecl.memberBlock.members {

            guard let variable = member.decl.as(VariableDeclSyntax.self),
                  let binding = variable.bindings.first,
                  let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
            else {
                continue
            }

            var hasValidateAttribute = false

            for attribute in variable.attributes {

                guard let attribute = attribute.as(AttributeSyntax.self) else {
                    continue
                }

                let attributeName = attribute.attributeName
                    .trimmedDescription

                if attributeName.hasSuffix("Validate") {
                    hasValidateAttribute = true
                    break
                }
            }

            guard hasValidateAttribute else {
                continue
            }

            let propertyName = identifier.identifier.text
            let capitalized =
                propertyName.prefix(1).uppercased() +
                propertyName.dropFirst()

            validations.append("!has\(capitalized)Error")
        }

        let body: String

        if validations.isEmpty {
            body = "true"
        } else {
            body = validations.joined(separator: " && ")
        }

        return [
            DeclSyntax(stringLiteral: """
            public var isValidForm: Bool {
                \(body)
            }
            """)
        ]
    }
}
