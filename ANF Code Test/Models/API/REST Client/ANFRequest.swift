//
//  ANFRequest.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

/**
 Parent Request class that can be triggered in the REST client
 */
class ANFRequest: NSObject, Identifiable {
    
    /// The http request method
    private(set) var requestMethod: ANFRequestMethod = .get
    
    /// The releative path of the request to the host
    private(set) var path: String = ""
    
    /// the body, when provided, for the request
    private(set) var body: [String: AnyHashable]?
    
    /// The unique identifer of the request, that can later be used to cancel or track
    let requestID: UUID = UUID()
    
    /// Create the url by combining the host and the path
    var url: URL {
        let defaultURL: URL = ANFHosts.api
        let apiBase: String = defaultURL.absoluteString
        let uri = apiBase.appending(path)
        
        guard let url = URL(string: uri) else {
            print("Invalid URL: \(uri). Returning base")
            return defaultURL
        }
        
        return url
    }
    
    /// Default initializer that each child will call with their nique properties
    /// - Parameters:
    ///   - requestMethod:  The http method
    ///   - path:           The request path
    ///   - body:           The body of the request
    init(
        requestMethod: ANFRequestMethod,
        path: String,
        body: [String : AnyHashable]? = nil
    ) {
        self.requestMethod = requestMethod
        self.path = path
        self.body = body
    }
}
