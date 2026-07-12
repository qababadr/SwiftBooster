//
//  ValidationRule.swift
//  SwiftBooster
//
//  Created by BADR  QABA on 2026-06-15.
//

public enum ValidationRule: Equatable {
    case required
    case email
    case url
    case minLength(Int)
    case maxLength(Int)
    case equalsTo(String)
    case length(Int, Int)
    case notBlank
    case pattern(String)
    case range(Double, Double)
}
