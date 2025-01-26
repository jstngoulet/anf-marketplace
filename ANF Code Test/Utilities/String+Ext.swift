//
//  String+Ext.swift
//  ANF Code Test
//
//  Created by Justin Goulet on 1/24/25.
//

import Foundation

extension String {
    
    var htmlString: NSAttributedString? {
        guard let data = data(using: .utf8),
              let attr = try? NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html
                    , .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
              )
        else { return nil }
        return attr
    }
    
    var strippedWebDataPrefix: String {
        let pattern = #"applewebdata:\/\/([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}\/%22)"#
        let revised = self.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
        return revised.removingPercentEncoding ?? revised
    }
    
}
