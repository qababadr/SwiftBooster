//
//  UrlExtension.swift
//  CoreApp
//
//  Created by BADR  QABA on 2026-02-15.
//
import Foundation
import UniformTypeIdentifiers

public extension URL {
    func mimeType() -> String {
        if let type = UTType(filenameExtension: self.pathExtension),
           let mime = type.preferredMIMEType {
            return mime
        }
        return "application/octet-stream"
    }
}
