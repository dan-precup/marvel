//
//  CacheService.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import CoreData
import Foundation

protocol CacheService {
    func getCachedDataIfNotExpired(forKey: String) -> Data?
    func setCachedData(forKey: String, data: Data)
}

final class CacheServiceImpl: CacheService {
    private let expiration: TimeInterval = 86400 // 1 day
    static let shared = CacheServiceImpl()
    private let storage: LocalStorageService
    
    private init(storage: LocalStorageService = ServiceRegistry.shared.localStorage) {
        self.storage = storage
    }
    
    func getCachedDataIfNotExpired(forKey key: String) -> Data? {
        clearExpired()
        guard let context = storage.getContext() else { return nil }
        let fetchRequest = NSFetchRequest<RequestCache>(entityName: "RequestCache")
        let predicate = NSPredicate(format: "cacheKey = %@", key)
        fetchRequest.predicate = predicate
        do {
            let settings = try context.fetch(fetchRequest) as [RequestCache]
            return settings.first?.data
        } catch {
            Log.error("Cannot get data from cache" ,error)
            return nil
        }
    }
    
    func setCachedData(forKey key: String, data: Data) {
        guard let context = storage.getContext() else { return }
        let entity = RequestCache(context: context)
        entity.data = data
        entity.expiresAt = Date().addingTimeInterval(expiration)
        entity.cacheKey = key
        storage.saveContext(context)
    }
    
    private func clearExpired() {
        guard let context = storage.getContext() else { return }
        let fetchRequest = NSFetchRequest<RequestCache>(entityName: "RequestCache")
        let predicate = NSPredicate(format: "expiresAt <= %@", Date() as NSDate)
        fetchRequest.predicate = predicate
        do {
            let cacheEntries = try context.fetch(fetchRequest) as [RequestCache]
            cacheEntries.forEach({ context.delete($0) })
            storage.saveContext(context)
        } catch {
            Log.error("Cannot delete expired cache" ,error)
        }
    }
}
