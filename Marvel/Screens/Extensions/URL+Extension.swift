//
//  URL+Extension.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation

extension URL {

    ///  Appends `queryItems` to the given URL
    /// - Parameter queryItems: The items
    /// - Returns: The updated url or the original one if no changes were performed
    func apending(_ queryItems: [URLQueryItem]) -> URL {
       
        guard var components = URLComponents(string: absoluteString) else {
            return self
        }
        var items = components.queryItems ?? []
        
        items.append(contentsOf: queryItems)
        components.queryItems = items
        return components.url ?? self
    }
}
