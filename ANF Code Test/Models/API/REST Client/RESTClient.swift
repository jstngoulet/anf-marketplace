//
//  RESTClient.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

/**
 Current base REST client
 */
final class RESTClient: NSObject {
    
    /**
     Provided errors that can be triggered within the client. DNI server error
     */
    public enum ANFRestClientError: LocalizedError {
        case invalidURL(String)
        case badRequest
        case invalidContract
        case noData
        
        public var errorDescription: String? {
            switch self {
            case .invalidURL(let url):
                return "Invalid URL: \(url)"
            case .badRequest:
                return "Bad Request"
            case .invalidContract:
                return "The contract in the request does not match the response."
            case .noData:
                return "No Data Returned from the Server"
            }
        }
    }
    
    /// Singleton to provide auth headers (not set)
    private static var shared: RESTClient = RESTClient()
    
    /// Additional headers to store in singleton
    private var additionalHeaders: [String: String] = [:]
    
    /// Whether logging is enabled for requests
    static var isLoggingEnabled: Bool = false
    
    /// Perform a request provided and return the data to be parsed.
    /// - Parameter request:    The request to submit
    /// - Returns:              The response data that can be decoded
    class func perform(request: ANFRequest) async throws -> Data {
        
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.requestMethod.rawValue
        
        shared.additionalHeaders.forEach({
            urlRequest.setValue($0, forHTTPHeaderField: $1)
        })
        
        if isLoggingEnabled {
            debugPrint([
                "request": urlRequest.url?.absoluteString ?? "Unknown URL",
                "method": request.requestMethod.rawValue
            ])
        }
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        if isLoggingEnabled {
            print("Raw Data: \(String(bytes: data, encoding: .utf8) ?? "None")")
        }
        
        return data
    }
}
