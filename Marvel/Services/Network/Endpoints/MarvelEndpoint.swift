//
//  MarvelEndpoint.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import CryptoKit
import Foundation

enum MarvelEndpoint {
    case heroList(_ page: Int, _ perPage: Int)
    case heroSearch(_ page: Int, _ perPage: Int, _ term: String)
    case heroComics(_ page: Int, _ perPage: Int, _ heroId: Int)
}

extension MarvelEndpoint: NetworkEndpoint {
    private var publicKey: String { "5ba3a348b1bcf94d616279390e00c82e" }
    private var privateKey: String { "5988398be5b8ed9e2f377c08cb50d414dd054640" }
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
            return makePagingURLQueryItems(page: page, perPage: perPage, additionalQueryItems: buildAuthQueryItems())
        case .heroSearch(let page, let perPage, let searchTerm):
            let additionalQueryItems = buildAuthQueryItems() + [URLQueryItem(name: "nameStartsWith", value: searchTerm)]
            return makePagingURLQueryItems(page: page,
                                           perPage: perPage,
                                           additionalQueryItems: additionalQueryItems)
        }
    }
    
    var localCacheSignature: String? {
        switch self {
        case .heroList(let page, let perPage):
            return "heroList_\(page)_\(perPage)"
        case .heroComics(let page, let perPage, let heroId):
            return "heroComics\(page)_\(perPage)_\(heroId)"
        case .heroSearch(let page, let perPage, let searchTerm):
            return "heroSearch\(page)_\(perPage)_\(searchTerm)"
        }
    }
    
    private func makePagingURLQueryItems(page: Int, perPage: Int, additionalQueryItems: [URLQueryItem] = []) -> [URLQueryItem] {
        [
            URLQueryItem(name: "offset", value: "\(page * perPage)"),
            URLQueryItem(name: "limit", value: "\(perPage)")
        ] + additionalQueryItems
    }
    
    /// Builds the auth data
    /// - Returns: The auth query items
    private func buildAuthQueryItems() -> [URLQueryItem] {
        let timestamp = Date.timeIntervalBetween1970AndReferenceDate
        let hashString = "\(timestamp)\(privateKey)\(publicKey)"
        let hash = Insecure.MD5
            .hash(data: hashString.data(using: .utf8)!)
            .map{String(format: "%02x", $0)}
            .joined()
        return [
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "ts", value: "\(timestamp)"),
            URLQueryItem(name: "apikey", value: publicKey)
        ]
    }
}
