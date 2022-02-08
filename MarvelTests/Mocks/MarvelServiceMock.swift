//
//  MarvelServiceMock.swift
//  MarvelTests
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import Combine
import Foundation
@testable import Marvel

final class MarvelServiceMock: MarvelService {
    var heroesResults: PagedResultsContainer<Hero>!
    var comicsResults: PagedResultsContainer<Comic>!
    var getHeroesCalled = false
    var searchHeroesCalled = false
    var getComicsCalled = false
    
    func getHeroes(page: Int, perPage: Int) -> AnyPublisher<PagedResultsContainer<Hero>, Error> {
        getHeroesCalled = true
        return Just(heroesResults)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func searchForHero(nameStartingWith: String, page: Int, perPage: Int) -> AnyPublisher<PagedResultsContainer<Hero>, Error> {
        searchHeroesCalled = true
        return Just(heroesResults)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getComics(with hero: Hero, page: Int, perPage: Int) -> AnyPublisher<PagedResultsContainer<Comic>, Error> {
        getComicsCalled = true
        return Just(comicsResults)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
