//
//  HeroListViewModelTests.swift
//  MarvelTests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//

import XCTest

class HeroListViewModelTests: XCTestCase {
    private var marvelService: MarvelServiceMock!
    private var hero: Hero!
    private var coordinator: MockHeroListCoordinator!
    private var sut: HeroListViewModelImpl!
    
    override func setUp() {
        super.setUp()
        marvelService = MarvelServiceMock()
        hero = HeroFactory.makeHero()
        marvelService.heroesResults = PagedResultsContainer(offset: 0, total: 1, count: 1, limit: 5, results: [hero])
        coordinator = MockHeroListCoordinator()
        sut = HeroListViewModelImpl(coordinator: coordinator, marvelService: marvelService)
    }
    
    func testVMDoesntSendRequestIfIsLoading() {
        marvelService.heroesResults = PagedResultsContainer(offset: 0, total: 100, count: 5, limit: 5, results: [hero])
        sut.isLoading.value = true
        sut.loadNextPageIfPossible()
        XCTAssertFalse(marvelService.searchHeroesCalled)
    }
    
    func testVMDoesntSendRequestIfLastPage() {
        sut.loadNextPageIfPossible()
        XCTAssertFalse(marvelService.searchHeroesCalled)
    }
    
    func testSelectingAHeroPresentsInTheCoordinator() {
        sut.didSelectHero(hero)
        XCTAssertTrue(coordinator.presentedHero)
    }
    
    func testSearchPresentsInTheCoordinator() {
        sut.didSelectSearch()
        XCTAssertTrue(coordinator.searchPresented)
    }
}
