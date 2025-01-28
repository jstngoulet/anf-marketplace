//
//  ANFHosts.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

/**
 List of hosts for the domain, includes parent path.
 - Note:    This list of hosts should be updated based on domain, subdomain and path provided
            elsewhere when more requests are provided
 */
enum ANFHosts {
    static let api = URL(string: "https://www.abercrombie.com/anf/nativeapp/qa/codetest/")!
}
