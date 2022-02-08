//
//  PagedResultsContainerTests.swift
//  MarvelTests
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import XCTest

class PagedResultsContainerTests: XCTestCase {

    func testHasNextPageCalculationWithNoRecordsIsFalse() throws {
        let sut = PagedResultsContainerFactory.make(results: [String]())
        XCTAssertFalse(sut.hasNextPage)
    }
    
    
    func testHasNextPageWithTotalGreaterThanCurrentIsTrue() throws {
        let sut = PagedResultsContainerFactory.make(total: 100, count: 10, results: [String]())
        XCTAssertTrue(sut.hasNextPage)
    }
    
    func testHasReachedLastPageResultsIsFalse() throws {
        let sut = PagedResultsContainerFactory.make(offset: 10, total: 100, count: 10, results: [String]())
        XCTAssertFalse(sut.hasNextPage)
    }
}
