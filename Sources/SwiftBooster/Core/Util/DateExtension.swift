//
//  DateExtension.swift
//  CoreApp
//
//  Created by BADR  QABA on 2026-02-18.
//
import Foundation

public extension Date {
    func toDateTimeString() -> String {
        return formatted(
            Date.FormatStyle()
                .day(.twoDigits)
                .month(.twoDigits)
                .year(.defaultDigits)
                .hour(.twoDigits(amPM: .wide))
                .minute(.twoDigits)
                .second(.twoDigits)
       )
    }
    
    func toDateString() -> String {
        return formatted(
            Date.FormatStyle()
                .day(.twoDigits)
                .month(.twoDigits)
                .year(.defaultDigits)
       )
    }
}
