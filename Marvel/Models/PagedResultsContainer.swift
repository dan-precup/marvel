//
//  PagedResultsContainer.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation

struct PagedResultsContainer <T: Codable>: Codable {
    let offset: Int
    let total: Int
    let count: Int
    let limit: Int
    let results: [T]
}
