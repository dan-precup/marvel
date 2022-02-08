//
//  SearchViewModelTests.swift
//  MarvelTests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//

import XCTest
import Combine
@testable import Marvel

class SearchViewModelTests: XCTestCase {
    private var marvelService: MarvelServiceMock!
    private var hero: Hero!
    private var coordinator: MockSearchCoordinator!
    private var sut: SearchViewModelImpl!
    
    override func setUp() {
        super.setUp()
        marvelService = MarvelServiceMock()
        hero = HeroFactory.makeHero()
        marvelService.heroesResults = PagedResultsContainer(offset: 0, total: 1, count: 1, limit: 5, results: [hero])
        coordinator = MockSearchCoordinator()
        sut = SearchViewModelImpl(coordinator: coordinator, marvelService: marvelService)
    }
    
    func testSearchingUpdatesTheTerm() {
        sut.didTypeSearchTerm("Iron man")
        var bag = Set<AnyCancellable>()
        let expectation = expectation(description: "Waiting for debouncer")
        
        sut.results.sink(receiveValue: { heros in
            if !heros.isEmpty {
                expectation.fulfill()
            }
        }).store(in: &bag)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(self.sut.term, "Iron man")
    }
    
    func testVMDoesntSendRequestIfLastPage() {
        sut.didTypeSearchTerm("Iron man")
        sut.loadNextPageIfPossible()
        XCTAssertFalse(marvelService.searchHeroesCalled)
    }
    
    func testVMDoesntSendRequestIfIsLoading() {
        marvelService.heroesResults = PagedResultsContainer(offset: 0, total: 100, count: 5, limit: 5, results: [hero])
        sut.didTypeSearchTerm("Iron man")
        sut.isLoading.value = true
        sut.loadNextPageIfPossible()
        XCTAssertFalse(marvelService.searchHeroesCalled)
    }
    
    func testVMDoesntSendRequestIfTermIsEmpty() {
        sut.didTypeSearchTerm("")
        sut.loadNextPageIfPossible()
        XCTAssertFalse(marvelService.searchHeroesCalled)
    }
    
    func testSelectingAHeroPushesInCoordinator() {
        sut.didSelectHero(hero)
        XCTAssertTrue(coordinator.didPushToHero)
    }
    
    
    func testSelectingAHeroDismissesSearch() {
        sut.didSelectHero(hero)
        XCTAssertTrue(coordinator.dismissed)
    }
    
    func testRunningNewSearchResetsTheResults() {
        // run initial search
        sut.didTypeSearchTerm("Iron man")
        let result = expectValue(of: sut.results.eraseToAnyPublisher(), equals: [[hero]])
        wait(for: [result.expectation], timeout: 2)
        XCTAssertEqual(sut.term, "Iron man")
        //Run the second search before it submits to the service
        sut.runSearch(on: "Captain America")
        XCTAssertEqual(sut.term, "Captain America")
        XCTAssertEqual(sut.results.value, [])
    }
}
