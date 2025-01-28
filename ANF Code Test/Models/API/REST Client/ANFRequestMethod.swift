//
//  ANFRequestMethod.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

/**
 Different request methods (HTTP)
 */
@frozen
public enum ANFRequestMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
}
