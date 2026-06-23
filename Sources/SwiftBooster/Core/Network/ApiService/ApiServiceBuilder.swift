//
//  ApiServiceBuilder.swift
//  CoreApp
//
//  Created by BADR  QABA on 2025-09-28.
//
import Foundation

/// Builder Creating ApiService instances with customizable parameters.
public class ApiServiceBuilder {
    
    private var baseUrl: String = ""
    private var timeout: Double = 0
    private var _withLogger: Bool = false
    private var _session: URLSession = URLSession.shared
    private var _background: Bool = false
    
    /// Sets the base URL for the ApiService.
    /// - Parameter stringUrl: The base URL string.
    /// - Returns: Self for chaining method calls.
    public func baseUrl(stringUrl: String) -> ApiServiceBuilder {
        baseUrl = stringUrl
        return self
    }
    
    /// Sets the timeout interval for network requests.
    /// - Parameter timeout: The timeout interval in seconds.
    /// - Returns: Self for chaining method calls.
    public func timeout(timeout: Double = 30) -> ApiServiceBuilder {
        self.timeout = timeout
        return self
    }
    
    /// Enables logging for network requests and responses.
    /// - Returns: Self for chaining method calls.
    public func withLogger() -> ApiServiceBuilder {
        _withLogger = true
        return self
    }
    
    ///Customizing the URLSession instance for requests
    /// - Returns: Self for chaining method calls.
    public func session(session: URLSession) -> ApiServiceBuilder {
        _session = session
        return self
    }
    
    ///Sets the background task to be enabled
    /// - Returns: Self for chaining method calls.
    public func withBackgroundTask() -> ApiServiceBuilder {
        _background = true
        return self
    }
    
    /// Builds and returns an instance of ApiService configured with the set parameters.
    /// - Returns: Configured instance of ApiService.
    public func build() -> ApiService {
        return ApiService(
            baseUrl: baseUrl,
            timeout: timeout,
            withLogger: _withLogger,
            session: _session,
            withBackground: _background
        )
    }
    
    public init(){}
}
