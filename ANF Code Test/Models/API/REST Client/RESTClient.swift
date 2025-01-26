//
//  RESTClient.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

final class RESTClient: NSObject {
    
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
    
    private static var shared: RESTClient = RESTClient()
    
    private var additionalHeaders: [String: String] = [:]
    
    static var isLoggingEnabled: Bool = false
    
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

//https://www.abercrombie.com/anf/nativeapp/qa/codetest/codeTest_exploreData.json
//https://www.abercrombie.com/anf/nativeapp/qa/codetest/code_Test_exploreData.json
