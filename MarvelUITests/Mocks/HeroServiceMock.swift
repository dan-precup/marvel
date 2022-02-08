//
//  HeroServiceMock.swift
//  MarvelUITests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//

import Combine
import Foundation

enum HeroMockFlag: String, CaseIterable {
    case heroes
    case heroNoDescription
    case search
    case noHeros
    case emptySearchResults
    case singleHero
    case noComics
    case comics
    
    static func extractListFromStrings(_ strings: [String]) -> [HeroMockFlag] {
        strings.compactMap({ HeroMockFlag(rawValue: $0) })
    }
}


final class HeroServiceMock: MarvelService {
    var heroesResults: PagedResultsContainer<Hero>!
    var comicsResults: PagedResultsContainer<Comic>!
    lazy var singleHero = HeroFactory.makeHero()
    
    
    init() {
        setHeores([])
        setComics([])
    }

    
    /// Shorthand hero setter
    /// - Parameter heros: The heros
    func setHeores(_ heros: [Hero]) {
        heroesResults = PagedResultsContainerFactory.make(offset: 0, total: heros.count, count: heros.count, limit: heros.count, results: heros)
    }
    
    /// Shorthand comics setter
    /// - Parameter comics: The comics
    func setComics(_ comics: [Comic]) {
        comicsResults = PagedResultsContainerFactory.make(offset: 0, total: comics.count, count: comics.count, limit: comics.count, results: comics)
    }
    
    func getHeroes(page: Int, perPage: Int) -> AnyPublisher<PagedResultsContainer<Hero>, Error> {
        return Just(heroesResults)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func searchForHero(nameStartingWith: String, page: Int, perPage: Int) -> AnyPublisher<PagedResultsContainer<Hero>, Error> {
        return Just(heroesResults)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getComics(with hero: Hero, page: Int, perPage: Int) -> AnyPublisher<PagedResultsContainer<Comic>, Error> {
        return Just(comicsResults)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    /// Translate the mock flags into actual entities
    /// - Parameter flags: The flags
    func setMockFlags(_ flags: [HeroMockFlag]) {
        setComics([])
        setHeores([])
        for flag in flags {
            switch flag {
            case .heroes:
                setHeores([HeroFactory.makeHero(), HeroFactory.makeHero(name: "Captain America")])
            case .heroNoDescription:
                setHeores([HeroFactory.makeHero(description: "")])
            case .search:
                setHeores([HeroFactory.makeHero(), HeroFactory.makeHero(name: "Iron Fist")])
            case .emptySearchResults, .noComics, .noHeros:
                break
            case .singleHero:
                setHeores([HeroFactory.makeHero()])
            case .comics:
                setComics([ComicFactory.make()])
            }
        }
        
    }
}
