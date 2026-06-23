//
//  StringExtension.swift
//  CoreApp
//
//  Created by BADR  QABA on 2026-02-09.
//

import Foundation

// MARK: - String Extension for Truncation
public extension String {
    func truncated(maxLength: Int = 100, suffix: String = ". . .") -> String {
        if self.count <= maxLength {
            return self
        }
        let index = self.index(self.startIndex, offsetBy: maxLength)
        return String(self[..<index]) + suffix
    }
    
    ///Returns a date representation of a specified string that the
    ///system interprets using the receiver’s current settings.
    ///- Returns : A date representation of string. If  can’t parse the string, returns nil.
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.date(from: self)
    }
    
    func stringAvatar() -> String {
        let parts = self.trimmingCharacters(in: .whitespacesAndNewlines)
                         .components(separatedBy: .whitespaces)
                         .filter { !$0.isEmpty }

        switch parts.count {
        case 2...:
            let firstInitial = parts[0].first?.uppercased() ?? ""
            let secondInitial = parts[1].first?.uppercased() ?? ""
            return firstInitial + secondInitial
        case 1:
            return String(parts[0].prefix(2)).uppercased()
        default:
            return ""
        }
    }
    
    var isValidEmail: Bool {
        guard !isEmpty else { return false }

        let emailPredicate = NSPredicate(
            format: "SELF MATCHES[c] %@",
            "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        )

        return emailPredicate.evaluate(with: self)
    }
}
