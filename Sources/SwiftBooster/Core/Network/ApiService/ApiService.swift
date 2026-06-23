//
//  ApiService.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import Foundation

private extension Data {
    mutating func append(_ string: String) {
        self.append(string.data(using: .utf8)!)
    }
}

internal enum HTTPRequestMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

/// Handles HTTP requests and responses, with support:
/// - GET, POST, PATCH and DELETE methods.
/// - Upload method
public final class ApiService: NSObject, Sendable {

    private let timeout: Double
    private let withLogger: Bool
    private let baseUrl: String?
    private let session: URLSession
    private let withBackground: Bool

    init(
        baseUrl: String? = nil,
        timeout: Double,
        withLogger: Bool,
        session: URLSession,
        withBackground: Bool
    ) {
        self.baseUrl = baseUrl
        self.timeout = timeout
        self.withLogger = withLogger
        self.withBackground = withBackground
        self.session = session
    }
    
    public func get<T: Sendable & Codable, Extra: Sendable & Codable>(
        endPoint: String,
        of: T.Type,
        baseUrl: String? = nil,
        headers: [String: String] = [:],
        decoder: JSONDecoder? = nil
    ) async throws -> ApiResponse<T,Extra> {
        let response = try await makeRequest(
            endPoint: endPoint,
            method: .GET,
            baseUrl: self.baseUrl ?? baseUrl,
            headers: headers
        )
        
        let usedDecoder: JSONDecoder = {
            if let d = decoder { return d }
            let defaultDecoder = JSONDecoder()
            defaultDecoder.dateDecodingStrategy = .iso8601
            return defaultDecoder
        }()
        
        let decodedResponse = try usedDecoder.decode(
            ApiResponse<T,Extra>.self,
            from: response
        )
        return decodedResponse
    }
    
    public func rawGet<T: Sendable & Codable>(
        endPoint: String,
        of: T.Type,
        baseUrl: String? = nil,
        headers: [String: String] = [:],
        decoder: JSONDecoder? = nil
    ) async throws -> T {
        let response = try await makeRequest(
            endPoint: endPoint,
            method: .GET,
            baseUrl: self.baseUrl ?? baseUrl,
            headers: headers
        )
        
        let usedDecoder: JSONDecoder = {
            if let d = decoder { return d }
            let defaultDecoder = JSONDecoder()
            defaultDecoder.dateDecodingStrategy = .iso8601
            return defaultDecoder
        }()
        
        let decodedResponse = try usedDecoder.decode(
            T.self,
            from: response
        )
        return decodedResponse
    }

    public func post<T: Sendable & Codable, Extra: Sendable & Codable>(
        endPoint: String,
        of: T.Type,
        data: Data?,
        baseUrl: String? = nil,
        headers: [String: String] = [:],
        decoder: JSONDecoder? = nil
    ) async throws -> ApiResponse<T,Extra> {
        let response = try await makeRequest(
            endPoint: endPoint,
            method: .POST,
            baseUrl: self.baseUrl ?? baseUrl,
            data: data,
            headers: headers
        )
        
        let usedDecoder: JSONDecoder = {
            if let d = decoder { return d }
            let defaultDecoder = JSONDecoder()
            defaultDecoder.dateDecodingStrategy = .iso8601
            return defaultDecoder
        }()
        
        let decodedResponse = try usedDecoder.decode(
            ApiResponse<T,Extra>.self,
            from: response
        )
        return decodedResponse
    }
    
    public func rawPost<T: Sendable & Codable>(
        endPoint: String,
        of: T.Type,
        data: Data?,
        baseUrl: String? = nil,
        headers: [String: String] = [:],
        decoder: JSONDecoder? = nil
    ) async throws -> T {
        let response = try await makeRequest(
            endPoint: endPoint,
            method: .POST,
            baseUrl: self.baseUrl ?? baseUrl,
            data: data,
            headers: headers
        )
        
        let usedDecoder: JSONDecoder = {
            if let d = decoder { return d }
            let defaultDecoder = JSONDecoder()
            defaultDecoder.dateDecodingStrategy = .iso8601
            return defaultDecoder
        }()
        
        let decodedResponse = try usedDecoder.decode(
            T.self,
            from: response
        )
        
        return decodedResponse
    }
    
    public func put<T: Sendable & Codable, Extra: Sendable & Codable>(
        endPoint: String,
        of: T.Type,
        data: Data?,
        baseUrl: String? = nil,
        headers: [String: String] = [:],
        decoder: JSONDecoder? = nil
    ) async throws -> ApiResponse<T,Extra> {
        let response = try await makeRequest(
            endPoint: endPoint,
            method: .PUT,
            baseUrl: self.baseUrl ?? baseUrl,
            data: data,
            headers: headers
        )
        
        let usedDecoder: JSONDecoder = {
            if let d = decoder { return d }
            let defaultDecoder = JSONDecoder()
            defaultDecoder.dateDecodingStrategy = .iso8601
            return defaultDecoder
        }()
        
        let decodedResponse = try usedDecoder.decode(
            ApiResponse<T,Extra>.self,
            from: response
        )
        
        return decodedResponse
    }
    
    public func patch<T: Sendable & Codable, Extra: Sendable & Codable>(
        endPoint: String,
        of: T.Type,
        data: Data?,
        baseUrl: String? = nil,
        headers: [String: String] = [:],
        decoder: JSONDecoder? = nil
    ) async throws -> ApiResponse<T,Extra> {
        let response = try await makeRequest(
            endPoint: endPoint,
            method: .PATCH,
            baseUrl: self.baseUrl ?? baseUrl,
            data: data,
            headers: headers
        )
        
        let usedDecoder: JSONDecoder = {
            if let d = decoder { return d }
            let defaultDecoder = JSONDecoder()
            defaultDecoder.dateDecodingStrategy = .iso8601
            return defaultDecoder
        }()
        
        let decodedResponse = try usedDecoder.decode(
            ApiResponse<T,Extra>.self,
            from: response
        )
        
        return decodedResponse
    }
    
    public func delete<T: Sendable & Codable, Extra: Sendable & Codable>(
        endPoint: String,
        of: T.Type,
        baseUrl: String? = nil,
        headers: [String: String] = [:],
        decoder: JSONDecoder? = nil
    ) async throws -> ApiResponse<T,Extra> {
        let response = try await makeRequest(
            endPoint: endPoint,
            method: .DELETE,
            baseUrl: self.baseUrl ?? baseUrl,
            headers: headers
        )
        
        let usedDecoder: JSONDecoder = {
            if let d = decoder { return d }
            let defaultDecoder = JSONDecoder()
            defaultDecoder.dateDecodingStrategy = .iso8601
            return defaultDecoder
        }()
        
        let decodedResponse = try usedDecoder.decode(
            ApiResponse<T,Extra>.self,
            from: response
        )
        
        return decodedResponse
    }
    
    public func download(
        url: String,
        fileName: String? = nil,
        headers: [String: String] = [:],
        progress: ((Double) -> Void)? = nil
    ) async throws -> URL {

        // ---- URL building (aligned with upload / post) ----
        guard let url = URL(string: url) else {
            throw ApiException(message: "The url \(url) is not valid")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        headers.forEach {
            request.setValue($1, forHTTPHeaderField: $0)
        }

        // ---- ResponseHeadersRead equivalent ----
        let (bytes, response): (URLSession.AsyncBytes, URLResponse)

        if withBackground {
            (bytes, response) = try await session.bytes(for: request)
        } else {
            (bytes, response) = try await session.bytes(for: request)
        }

        if withLogger {
            ApiServiceLogger.log(
                request: request,
                response: response,
                data: nil // streaming → no body yet
            )
        }

        guard let http = response as? HTTPURLResponse else {
            throw ApiException(message: "Invalid response")
        }

        // ---- HTTP error handling (Laravel-aware) ----
        if !(200...299).contains(http.statusCode) {

            var errorData = Data()
            for try await byte in bytes {
                errorData.append(byte)
            }

            if let errorResponse = try? JSONDecoder().decode(ApiException.self, from: errorData) {
                throw ApiException(
                    message: errorResponse.message,
                    errors: errorResponse.errors,
                    statusCode: http.statusCode
                )
            }

            throw ApiException(
                message: HTTPURLResponse.localizedString(forStatusCode: http.statusCode),
                statusCode: http.statusCode
            )
        }

        // ---- Content length ----
        let totalBytes = http.expectedContentLength
        var receivedBytes: Int64 = 0

        // ---- Destination ----
        let downloads = FileManager.default
            .urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        
        // ---- Resolve file name ----
        let resolvedFileName: String = {
            if let fileName, !fileName.isEmpty {
                return fileName
            }

            let lastPath = url.lastPathComponent

            // If URL ends with / or has no filename
            if lastPath.isEmpty || lastPath == "/" {
                return UUID().uuidString
            }

            return lastPath
        }()

        var destination = downloads.appendingPathComponent(resolvedFileName)
        
        // ---- Prevent overwrite (like browser behavior) ----
        var counter = 1
        while FileManager.default.fileExists(atPath: destination.path) {
            let name = destination.deletingPathExtension().lastPathComponent
            let ext = destination.pathExtension

            let newName = ext.isEmpty
                ? "\(name)(\(counter))"
                : "\(name)(\(counter)).\(ext)"

            destination = downloads.appendingPathComponent(newName)
            counter += 1
        }

        FileManager.default.createFile(
            atPath: destination.path,
            contents: nil,
            attributes: nil
        )

        let handle = try FileHandle(forWritingTo: destination)
        defer { try? handle.close() }

        // ---- Streaming write (C# Stream.CopyToAsync) ----
        var buffer = Data()
        buffer.reserveCapacity(8192)

        for try await byte in bytes {
            buffer.append(byte)

            if buffer.count >= 8192 {
                try handle.write(contentsOf: buffer)
                receivedBytes += Int64(buffer.count)
                buffer.removeAll(keepingCapacity: true)

                if totalBytes > 0 {
                    progress?(Double(receivedBytes) / Double(totalBytes) * 100)
                }
            }
        }

        // ---- Flush remaining ----
        if !buffer.isEmpty {
            try handle.write(contentsOf: buffer)
            receivedBytes += Int64(buffer.count)

            if totalBytes > 0 {
                progress?(Double(receivedBytes) / Double(totalBytes) * 100)
            }
        }

        return destination
    }
    
//    public static func download(
//        url: String,
//        headers: [String: String] = [:],
//        overwrite: Bool = false,
//        progress: (@Sendable (Double) -> Void)? = nil
//    ) async throws -> URL {
//
//        // ---- URL building ----
//        guard let url = URL(string: url) else {
//            throw ApiException(message: "The url \(url) is not valid")
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        headers.forEach {
//            request.setValue($1, forHTTPHeaderField: $0)
//        }
//
//        let session: URLSession = .shared
//        let (bytes, response) = try await session.bytes(for: request)
//
//        guard let http = response as? HTTPURLResponse else {
//            throw ApiException(message: "Invalid response")
//        }
//
//        // ---- HTTP error handling ----
//        if !(200...299).contains(http.statusCode) {
//
//            var errorData = Data()
//            for try await byte in bytes {
//                errorData.append(byte)
//            }
//
//            if let errorResponse = try? JSONDecoder().decode(ApiException.self, from: errorData) {
//                throw ApiException(
//                    message: errorResponse.message,
//                    errors: errorResponse.errors,
//                    statusCode: http.statusCode
//                )
//            }
//
//            throw ApiException(
//                message: HTTPURLResponse.localizedString(forStatusCode: http.statusCode),
//                statusCode: http.statusCode
//            )
//        }
//
//        // ---- Content length ----
//        let totalBytes = http.expectedContentLength
//        var receivedBytes: Int64 = 0
//
//        // ---- Destination ----
//        let downloads = FileManager.default
//            .urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//        try FileManager.default.createDirectory(
//            at: downloads,
//            withIntermediateDirectories: true
//        )
//
//        let resolvedFileName: String = {
//            let lastPath = url.lastPathComponent
//            if lastPath.isEmpty || lastPath == "/" {
//                return UUID().uuidString
//            }
//            return lastPath
//        }()
//
//        var destination = downloads.appendingPathComponent(resolvedFileName)
//
//        if overwrite {
//            // ✅ Remove existing file if overwrite enabled
//            if FileManager.default.fileExists(atPath: destination.path) {
//                try FileManager.default.removeItem(at: destination)
//            }
//        } else {
//            // ✅ Browser-style auto rename
//            var counter = 1
//            while FileManager.default.fileExists(atPath: destination.path) {
//                let name = destination.deletingPathExtension().lastPathComponent
//                let ext = destination.pathExtension
//
//                let newName = ext.isEmpty
//                    ? "\(name)(\(counter))"
//                    : "\(name)(\(counter)).\(ext)"
//
//                destination = downloads.appendingPathComponent(newName)
//                counter += 1
//            }
//        }
//
//        FileManager.default.createFile(
//            atPath: destination.path,
//            contents: nil,
//            attributes: nil
//        )
//
//        let handle = try FileHandle(forWritingTo: destination)
//        defer { try? handle.close() }
//
//        // ---- Streaming write ----
//        var buffer = Data()
//        buffer.reserveCapacity(8192)
//
//        for try await byte in bytes {
//            buffer.append(byte)
//
//            if buffer.count >= 8192 {
//                try handle.write(contentsOf: buffer)
//                receivedBytes += Int64(buffer.count)
//                buffer.removeAll(keepingCapacity: true)
//
//                if totalBytes > 0 {
//                    progress?(Double(receivedBytes) / Double(totalBytes) * 100)
//                }
//            }
//        }
//
//        if !buffer.isEmpty {
//            try handle.write(contentsOf: buffer)
//            receivedBytes += Int64(buffer.count)
//
//            if totalBytes > 0 {
//                progress?(Double(receivedBytes) / Double(totalBytes) * 100)
//            }
//        }
//
//        return destination
//    }

    public static func download(
        url: String,
        headers: [String: String] = [:],
        overwrite: Bool = false,
        progress: (@Sendable (Double) -> Void)? = nil
    ) async throws -> URL {

        // Validate URL
        guard let remoteURL = URL(string: url) else {
            throw NSError(domain: "Download", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: remoteURL)
        request.httpMethod = "GET"
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        // Download bytes
        let session = URLSession.shared
        let (bytes, response) = try await session.bytes(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Download", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }

        let totalBytes = httpResponse.expectedContentLength
        var receivedBytes: Int64 = 0
        var buffer = Data()

        for try await byte in bytes {
            buffer.append(byte)
            receivedBytes += 1

            if totalBytes > 0 {
                progress?(Double(receivedBytes) / Double(totalBytes) * 100)
            }
        }

        // Destination URL in Documents folder
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        try FileManager.default.createDirectory(at: documents, withIntermediateDirectories: true)

        var fileName = remoteURL.lastPathComponent
        if fileName.isEmpty { fileName = UUID().uuidString }
        var destination = documents.appendingPathComponent(fileName)

        if !overwrite {
            var counter = 1
            while FileManager.default.fileExists(atPath: destination.path) {
                let name = destination.deletingPathExtension().lastPathComponent
                let ext = destination.pathExtension
                let newName = ext.isEmpty ? "\(name)(\(counter))" : "\(name)(\(counter)).\(ext)"
                destination = documents.appendingPathComponent(newName)
                counter += 1
            }
        } else if FileManager.default.fileExists(atPath: destination.path) {
            try FileManager.default.removeItem(at: destination)
        }

        // Write data atomically
        try buffer.write(to: destination, options: .atomic)

        return destination
    }
    
    public func upload<T: Codable & Sendable, Body: Codable & Sendable>(
        endPoint: String,
        fileUrl: URL,
        filename: String,
        contentType: String,
        additionalData: Body? = nil,
        mediaField: String = "file",
        headers: [String: String] = [:],
        decoder: JSONDecoder? = nil
    ) async throws -> ApiResponse<T, Body> {

        // ---- URL building (safe) ----
        let stringUrl = (baseUrl ?? self.baseUrl ?? "") + endPoint
        guard let url = URL(string: stringUrl) else {
            throw ApiException(message: "The url \(stringUrl) is not valid")
        }

        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        var body = Data()

        // ---- 1️⃣ File part ----
        let fileData = try Data(contentsOf: fileUrl)

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(mediaField)\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(contentType)\r\n\r\n")
        body.append(fileData)
        body.append("\r\n")

        // ---- 2️⃣ Additional data (JSON-safe, Laravel-friendly) ----
        if let additionalData {
            let jsonData = try JSONEncoder().encode(additionalData)
            let object = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] ?? [:]

            for (key, value) in object {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }

        // ---- 3️⃣ Closing boundary ----
        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        do {
            let (data, response) = try await session.data(for: request)

            if withLogger {
                ApiServiceLogger.log(
                    request: request,
                    response: response,
                    data: data
                )
            }

            guard let http = response as? HTTPURLResponse else {
                throw ApiException(message: "Invalid response")
            }

            // ---- Error handling (Laravel-aware) ----
            if !(200...299).contains(http.statusCode) {
                if let errorResponse = try? JSONDecoder().decode(ApiException.self, from: data) {
                    throw ApiException(
                        message: errorResponse.message,
                        errors: errorResponse.errors,
                        statusCode: http.statusCode
                    )
                }

                throw ApiException(
                    message: HTTPURLResponse.localizedString(forStatusCode: http.statusCode),
                    statusCode: http.statusCode
                )
            }
            
            let usedDecoder: JSONDecoder = {
                if let d = decoder { return d }
                let defaultDecoder = JSONDecoder()
                defaultDecoder.dateDecodingStrategy = .iso8601
                return defaultDecoder
            }()

            // ---- Decode success ----
            return try usedDecoder.decode(
                ApiResponse<T, Body>.self,
                from: data
            )

        } catch {
            throw handleException(error)
        }
    }

    public static func buildFormData(
        _ withJSONObject: Any,
        options opt: JSONSerialization.WritingOptions = []
    ) throws -> Data {
        return try JSONSerialization.data(
            withJSONObject: withJSONObject,
            options: opt
        )
    }


    static func encodeFormData(formData: [String: String]) throws -> Data {
        let formBody = formData.map { key, value in
            "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }.joined(separator: "&")

        guard let encodedData = formBody.data(using: .utf8) else {
            throw ApiException(message: "Unable to encode form data")
        }
        return encodedData
    }

    private func makeRequest(
        endPoint: String,
        method: HTTPRequestMethod,
        baseUrl: String? = nil,
        data: Data? = nil,
        headers: [String: String] = [:]
    ) async throws -> Data {
        let stringUrl = (baseUrl ?? self.baseUrl ?? "") + endPoint
        guard let url = URL(string: stringUrl) else {
            throw ApiException(message: "The url \(stringUrl) is not valid")
        }

        let request: URLRequest = {
            var req = URLRequest(url: url)
            req.httpMethod = method.rawValue
            req.timeoutInterval = timeout
            req.setValue("application/json", forHTTPHeaderField: "Accept")

            if method == .PUT || method == .POST || method == .PATCH {
                if let bodyData = data {
                    req.httpBody = bodyData
                }
                req.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
            }

            headers.forEach { key, value in
                req.addValue(value, forHTTPHeaderField: key)
            }

            return req
        }()
        
        do {
            let (data, response): (Data, URLResponse)

            if withBackground {
                (data, response) = try await session.data(for: request)
            } else {
                (data, response) = try await withTaskCancellationHandler {
                    try await session.data(for: request)
                } onCancel: {
                    let task = session.downloadTask(with: request)
                    task.resume()
                }
            }

            if withLogger {
                ApiServiceLogger.log(
                    request: request,
                    response: response,
                    data: data
                )
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiException(message: "Invalid response")
            }

            if !(200...299).contains(httpResponse.statusCode) {
                if let errorResponse = try? JSONDecoder().decode(ApiException.self, from: data) {
                    // attach the HTTP status code manually
                    throw ApiException(
                        message: errorResponse.message,
                        errors: errorResponse.errors,
                        statusCode: httpResponse.statusCode
                    )
                } else {
                    throw ApiException(
                        message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode),
                        statusCode: httpResponse.statusCode
                    )
                }
            }
            
            return data

        } catch {
            throw handleException(error)
        }
    }

    private func handleException(
        _ error: Error,
        response: HTTPURLResponse? = nil
    ) -> ApiException {

        switch error {
        case let urlError as URLError:
            return ApiException(
                message: urlError.localizedDescription,
                errors: nil,
                statusCode: response?.statusCode
            )

        case is DecodingError:
            return ApiException(
                message: "Error deserializing the response.",
                errors: nil,
                statusCode: response?.statusCode
            )

        case is CancellationError:
            return ApiException(
                message: "Request was canceled.",
                errors: nil,
                statusCode: response?.statusCode
            )

        case let apiError as ApiException:
            // Already an ApiException from Laravel
            return apiError

        default:
            return ApiException(
                message: error.localizedDescription,
                errors: nil,
                statusCode: response?.statusCode
            )
        }
    }



}
