//
//  PagedResultsContainerFactory.swift
//  MarvelTests
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import Foundation
@testable import Marvel

final class PagedResultsContainerFactory {
    static func make<T: Codable>(offset: Int = 0, total: Int = 0, count: Int = 0, limit: Int = 5, results: [T]) -> PagedResultsContainer<T>  {
        PagedResultsContainer(offset: offset,
                              total: total,
                              count: count,
                              limit: limit,
                              results: results)
    }
}
