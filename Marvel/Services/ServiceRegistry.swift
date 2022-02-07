//
//  ServiceRegistry.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation

final class ServiceRegistry {
    
    /// Singleton instance
    static let shared = ServiceRegistry()
    private init() {}
    
    /// The local persistence layer
    let localStorage: LocalStorageService = CoreDataStorage()
    
    /// The marvel service
    lazy var marvelService: MarvelService = MarvelServiceImpl.shared
    
    /// The cache service
    lazy var cacheService: CacheService = CacheServiceImpl.shared
}
