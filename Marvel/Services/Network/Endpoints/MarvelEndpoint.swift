//
//  MarvelEndpoint.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation

enum MarvelEndpoint {
    case heroList(_ page: Int, _ perPage: Int)
    case heroSearch(_ page: Int, _ perPage: Int, _ term: String)
    case heroComics(_ page: Int, _ perPage: Int, _ heroId: Int)
}

extension MarvelEndpoint: NetworkEndpoint {
    private var baseURL: URL {  URL(string: "https://gateway.marvel.com:443/v1/public/characters")! }
    var url: URL {
        switch self {
        case .heroList, .heroSearch:
            return baseURL
        case .heroComics(_, _, let heroId):
            return baseURL.appendingPathComponent("\(heroId)/comics")
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .heroList(let page, let perPage), .heroComics(let page, let perPage, _):
            return makePagingURLQueryItems(page: page, perPage: perPage)
        case .heroSearch(let page, let perPage, let searchTerm):
            return makePagingURLQueryItems(page: page,
                                           perPage: perPage,
                                           additionalQueryItems: [URLQueryItem(name: "nameStartsWith", value: searchTerm)])
        }
    }
    
    private func makePagingURLQueryItems(page: Int, perPage: Int, additionalQueryItems: [URLQueryItem] = []) -> [URLQueryItem] {
        [
            URLQueryItem(name: "offset", value: "\(page * perPage)"),
            URLQueryItem(name: "limit", value: "\(perPage)")
        ]
    }
}
