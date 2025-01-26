//
//  ANFResponse.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/26/25.
//

import Foundation

/**
 The parent class for a Response object, in which each object
 must abide by in the request
 */
protocol ANFResponse: Codable {
    /// The ending result of the function. Codable
    /// so that we can put almost any object in there, but can
    /// be mapped from a JSON object if it needs to be passed
    /// out of the abstraction layer
    var result: Result<Codable, Error> { get }
}
