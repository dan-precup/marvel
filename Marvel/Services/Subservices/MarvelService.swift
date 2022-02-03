//
//  MarvelService.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Combine
import Foundation

protocol MarvelService {
    func getHeroes(page: Int, perPage: Int) -> AnyPublisher<PagedResultsContainer<Hero>, Error>
    func searchForHero(nameStartingWith: String, page: Int, perPage: Int) -> AnyPublisher<PagedResultsContainer<Hero>, Error>
}


final class MarvelServiceImpl: MarvelService {
    
    static let shared = MarvelServiceImpl()
    
    /// Network service
    private let networkService: NetworkService
    
    private init(networkService: NetworkService = NetworkServiceImpl.shared) {
        self.networkService = networkService
    }
    
    /// Get the hero list
    /// - Parameters:
    ///   - page: Current page
    ///   - perPage: How many per page
    /// - Returns: Paged results of heroes
    func getHeroes(page: Int, perPage: Int) -> AnyPublisher<PagedResultsContainer<Hero>, Error> {
        networkService.request(from: MarvelEndpoint.heroList(page, perPage),
                               decodingTo: DataContainer<PagedResultsContainer<Hero>>.self)
            .map({ $0.data })
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
    
    /// Get the list of heroes whose name starts with a given term
    /// - Parameters:
    ///   - nameStartingWith: The search term
    ///   - page: Current page
    ///   - perPage: How many per page
    /// - Returns: Paged results of heroes
    func searchForHero(nameStartingWith: String, page: Int, perPage: Int) -> AnyPublisher<PagedResultsContainer<Hero>, Error>  {
        networkService.request(from: MarvelEndpoint.heroSearch(page, perPage, nameStartingWith),
                               decodingTo: DataContainer<PagedResultsContainer<Hero>>.self)
            .map({ $0.data })
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
}
