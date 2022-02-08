//
//  HeroDetailsViewModelTest.swift
//  MarvelTests
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import XCTest

class HeroDetailsViewModelTest: XCTestCase {
    private let marvelService = MarvelServiceMock()

    func testHeroWithDescriptionFeedHasDescription() {
        let hero = HeroFactory.makeHero()
        marvelService.comicsResults = PagedResultsContainer(offset: 0, total: 1, count: 1, limit: 5, results: [ComicFactory.make()])
        let sut = HeroDetailsViewModelImpl(hero: hero, marvelService: marvelService)
        sut.didFinishLoading()
        let containsValue = sut.cells.value.contains(where: {
            if case .description(let str) = $0, str == hero.description {
                return true
            }
            
            return false
        })
        
        XCTAssertTrue(containsValue)
    }
    
    func testHeroWithoutDescriptionGetsRedactedDefaultValue() {
        let hero = HeroFactory.makeHero(description: "")
        marvelService.comicsResults = PagedResultsContainer(offset: 0, total: 1, count: 1, limit: 5, results: [ComicFactory.make()])
        let sut = HeroDetailsViewModelImpl(hero: hero, marvelService: marvelService)
        sut.didFinishLoading()
        let containsValue = sut.cells.value.contains(where: {
            if case .description(let str) = $0, str == "🚨 🚨 🚨 Redacted 🚨 🚨 🚨" {
                return true
            }
            
            return false
        })
        
        XCTAssertTrue(containsValue)
    }
    
    
    func testHeroWithDescriptionFeedHasDescriptionTitle() {
        let hero = HeroFactory.makeHero()
        marvelService.comicsResults = PagedResultsContainer(offset: 0, total: 1, count: 1, limit: 5, results: [ComicFactory.make()])
        let sut = HeroDetailsViewModelImpl(hero: hero, marvelService: marvelService)
        sut.didFinishLoading()
        let containsValue = sut.cells.value.contains(where: {
            if case .title(let str) = $0, str == "About"{
                return true
            }
            
            return false
        })
        
        XCTAssertTrue(containsValue)
    }
    
    
    
    func testHeroWithComicsHasComicsFeed() {
        let hero = HeroFactory.makeHero()
        let injectedComic = ComicFactory.make()
        marvelService.comicsResults = PagedResultsContainer(offset: 0, total: 1, count: 1, limit: 5, results: [injectedComic])
        let sut = HeroDetailsViewModelImpl(hero: hero, marvelService: marvelService)
        sut.didFinishLoading()
        let cells: [HeroDetailsCells] = [
            .imageAndName(hero),
            .title("Stats"),
            .stats(hero),
            .title("About"),
            .description(hero.description),
                .title("Comics"),
            .comic(injectedComic)
        ]
        
        let result = expectValue(of: sut.cells.eraseToAnyPublisher(), equals: [cells])
        sut.didFinishLoading()
        wait(for: [result.expectation], timeout: 1)
    }

    func testHeroWithoutComicsDoesntHaveComicsInFeed() {
        let hero = HeroFactory.makeHero()
        marvelService.comicsResults = PagedResultsContainer(offset: 0, total: 1, count: 1, limit: 5, results: [])
        let sut = HeroDetailsViewModelImpl(hero: hero, marvelService: marvelService)
        sut.didFinishLoading()
        let cells: [HeroDetailsCells] = [
            .imageAndName(hero),
            .title("Stats"),
            .stats(hero),
            .title("About"),
            .description(hero.description),
        ]
        
        let result = expectValue(of: sut.cells.eraseToAnyPublisher(), equals: [cells])
        sut.didFinishLoading()
        wait(for: [result.expectation], timeout: 1)
    }
    
    
    func testVMDoesntSendRequestIfLastPage() {
        let hero = HeroFactory.makeHero()
        marvelService.comicsResults = PagedResultsContainer(offset: 0, total: 1, count: 1, limit: 5, results: [])
        let sut = HeroDetailsViewModelImpl(hero: hero, marvelService: marvelService)
        sut.didFinishLoading()
        marvelService.getComicsCalled = false
        sut.loadNextPageIfPossible()
        XCTAssertFalse(marvelService.getComicsCalled)
    }
    
    func testVMDoesntSendRequestIfIsLoading() {
        let hero = HeroFactory.makeHero()
        marvelService.comicsResults = PagedResultsContainer(offset: 0, total: 10, count: 5, limit: 5, results: [])
        let sut = HeroDetailsViewModelImpl(hero: hero, marvelService: marvelService)
        sut.didFinishLoading()
        marvelService.getComicsCalled = false
        sut.isLoading.value = true
        sut.loadNextPageIfPossible()
        XCTAssertFalse(marvelService.getComicsCalled)
    }
}
