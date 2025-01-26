//
//  ANFRequest.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

class ANFRequest: NSObject, Identifiable {
    
    private(set) var requestMethod: ANFRequestMethod = .get
    
    private(set) var path: String = ""
    
    private(set) var body: [String: AnyHashable]?
    
    let requestID: UUID = UUID()
    
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
