//
//  IntExtension.swift
//  CoreApp
//
//  Created by BADR  QABA on 2026-02-10.
//

import Foundation

public extension Int64 {
    
    /// Returns a date representation of a specific timestamp
    /// - Returns: A date from timestamp formatted as "dd-MM-yyyy"
    func toDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        // Convert the timestamp to Date
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        // Return the formatted date string
        return formatter.string(from: date)
    }
    
    func toAbbreviated(decimalPlaces: Int = 1) -> String {
            var value = Double(self)
            var suffix = ""
            
            if self >= 1_000_000_000 {
                value = value / 1_000_000_000
                suffix = "B"
            } else if self >= 1_000_000 {
                value = value / 1_000_000
                suffix = "M"
            } else if self >= 1_000 {
                value = value / 1_000
                suffix = "K"
            }
            
            if value.truncatingRemainder(dividingBy: 1) == 0 {
                return "\(Int(value))\(suffix)"
            } else {
                let factor = pow(10.0, Double(decimalPlaces))
                let rounded = (value * factor).rounded() / factor
                return "\(rounded)\(suffix)"
            }
        }
}
