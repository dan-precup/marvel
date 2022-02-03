//
//  NetworkEndpoint.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation

enum HTTPContentType: String {
    case json = "application/json"
}

enum NetworkMethod: String {
    case get = "GET"
}

protocol NetworkEndpoint {
    var url: URL { get }
    var method: NetworkMethod { get }
    var queryItems: [URLQueryItem] { get }
    var contentType: HTTPContentType { get }
    var caching: URLRequest.CachePolicy { get }
    var timeout: TimeInterval { get }
}

extension NetworkEndpoint {
    var method: NetworkMethod { .get }
    var queryItems: [URLQueryItem] { [] }
    var contentType: HTTPContentType { .json }
    var caching: URLRequest.CachePolicy { .reloadRevalidatingCacheData }
    var timeout: TimeInterval { 30 }
}
