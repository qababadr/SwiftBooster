//
//  ValidateMacro.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-15.
//

import SwiftSyntax
import SwiftSyntaxMacros
import Foundation

public struct ValidateMacro: PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        guard let variable = declaration.as(VariableDeclSyntax.self),
              let binding = variable.bindings.first,
              let identifier = binding.pattern.as(IdentifierPatternSyntax.self)
        else {
            return []
        }

        let propertyName = identifier.identifier.text
        let capitalized =
            propertyName.prefix(1).uppercased() + propertyName.dropFirst()

        // Generate only once (for the first @Validate attribute)
        var firstValidateAttribute: AttributeSyntax?

        for attribute in variable.attributes {

            guard let attribute = attribute.as(AttributeSyntax.self) else {
                continue
            }

            if attribute.attributeName.trimmedDescription == "Validate" {
                firstValidateAttribute = attribute
                break
            }
        }

        guard let firstValidateAttribute else {
            return []
        }

        guard firstValidateAttribute.description == node.description else {
            return []
        }

        var conditions: [String] = []

        for attributeElement in variable.attributes {

            guard let attribute = attributeElement.as(AttributeSyntax.self) else {
                continue
            }

            guard attribute.attributeName.trimmedDescription == "Validate" else {
                continue
            }

            guard let args = attribute.arguments?.as(LabeledExprListSyntax.self),
                  let expression = args.first?.expression
            else {
                continue
            }

            let value = expression.description
                .trimmingCharacters(in: .whitespacesAndNewlines)

            let condition: String

            if value == ".required" {

                condition = generateRequired(
                    propertyName: propertyName
                )

            } else if value == ".email" {

                condition = generateIsValidEmail(
                    propertyName: propertyName
                )

            } else if value.contains("equalsTo") {

                let otherProperty = value
                    .replacingOccurrences(of: ".equalsTo(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                    .replacingOccurrences(of: "\"", with: "")

                condition = generateEqualsTo(
                    propertyName: propertyName,
                    otherPropertyName: otherProperty
                )

            } else if value.contains("minLength") {

                let count = value
                    .replacingOccurrences(of: ".minLength(", with: "")
                    .replacingOccurrences(of: ")", with: "")

                condition = generateMinLength(
                    propertyName: propertyName,
                    length: Int(count) ?? 0
                )

            } else if value.contains("maxLength") {

                let count = value
                    .replacingOccurrences(of: ".maxLength(", with: "")
                    .replacingOccurrences(of: ")", with: "")

                condition = generateMaxLength(
                    propertyName: propertyName,
                    length: Int(count) ?? 0
                )

            } else if value.contains("length") {

                let parameters = value
                    .replacingOccurrences(of: ".length(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                    .split(separator: ",")

                let min = Int(
                    parameters.first?
                        .trimmingCharacters(in: .whitespaces) ?? ""
                ) ?? 0

                let max = Int(
                    parameters.last?
                        .trimmingCharacters(in: .whitespaces) ?? ""
                ) ?? 0

                condition = generateLength(
                    propertyName: propertyName,
                    min: min,
                    max: max
                )

            } else if value == ".notBlank" {

                condition = generateNotBlank(
                    propertyName: propertyName
                )

            } else if value.contains("pattern") {

                let pattern = value
                    .replacingOccurrences(of: ".pattern(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                    .replacingOccurrences(of: "\"", with: "")

                condition = generatePattern(
                    propertyName: propertyName,
                    pattern: pattern
                )

            } else if value.contains("range") {

                let parameters = value
                    .replacingOccurrences(of: ".range(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                    .split(separator: ",")

                let min = Double(
                    parameters.first?
                        .trimmingCharacters(in: .whitespaces) ?? ""
                ) ?? 0

                let max = Double(
                    parameters.last?
                        .trimmingCharacters(in: .whitespaces) ?? ""
                ) ?? 0

                condition = generateRange(
                    propertyName: propertyName,
                    min: min,
                    max: max
                )

            } else {
                continue
            }

            conditions.append(condition)
        }

        guard !conditions.isEmpty else {
            return []
        }

        let body = conditions.joined(separator: " || ")

        return [
            DeclSyntax(stringLiteral: """
            public var has\(capitalized)Error: Bool {
                \(body)
            }
            """)
        ]
    }

    // MARK: - Rule generators

    private static func generateRequired(
        propertyName: String
    ) -> String {
        "\(propertyName).isEmpty"
    }

    private static func generateIsValidEmail(
        propertyName: String
    ) -> String {
        "!\(propertyName).isValidEmail"
    }

    private static func generateEqualsTo(
        propertyName: String,
        otherPropertyName: String
    ) -> String {
        "\(propertyName) != \(otherPropertyName)"
    }

    private static func generateMinLength(
        propertyName: String,
        length: Int
    ) -> String {
        "\(propertyName).count < \(length)"
    }

    private static func generateMaxLength(
        propertyName: String,
        length: Int
    ) -> String {
        "\(propertyName).count > \(length)"
    }
    
    private static func generateLength(
        propertyName: String,
        min: Int,
        max: Int
    ) -> String {
        "\(propertyName).count < \(min) || \(propertyName).count > \(max)"
    }

    private static func generateNotBlank(
        propertyName: String
    ) -> String {
        "\(propertyName).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty"
    }

    private static func generatePattern(
        propertyName: String,
        pattern: String
    ) -> String {

        """
        {
            let regex = NSPredicate(
                format: "SELF MATCHES %@",
                "\(pattern)"
            )

            return !regex.evaluate(with: \(propertyName))
        }()
        """
    }

    private static func generateRange(
        propertyName: String,
        min: Double,
        max: Double
    ) -> String {
        "\(propertyName) < \(min) || \(propertyName) > \(max)"
    }
}
