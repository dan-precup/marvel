//
//  LocalStorageService.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import CoreData
import Foundation

protocol LocalStorageService {
    func getContext() -> NSManagedObjectContext?
    func saveContext(_ subContext: NSManagedObjectContext?)
    func setContextFrom(_ storeContainer: NSPersistentContainer)
    func getMainContext() -> NSManagedObjectContext?
}

final class CoreDataStorage: LocalStorageService {
    private let persistentContainer: NSPersistentContainer
    private var mainContext: NSManagedObjectContext?
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Marvel")
        persistentContainer.loadPersistentStores(completionHandler: {[weak self] (storeDescription, error) in
            if let error = error as NSError? {
                Log.error("Unresolved error \(error), \(error.userInfo)")
                return
            }
            self?.mainContext = self?.persistentContainer.viewContext
        })
    }
    
    
    /// Get a thread safe child context that has the parent context already set.
    /// - Returns: NSManagedObjectContext if the main context is set and nil otherwise
    func getContext() -> NSManagedObjectContext? {
        guard let mainContext = mainContext else { return nil }
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        return context
    }
    
    /// Sets the main context form a persistent container
    /// - Parameter storeContainer: The persistent container
    func setContextFrom(_ storeContainer: NSPersistentContainer) {
        mainContext = storeContainer.viewContext
    }
    
    /// The a read-safe context (returns the main context)
    /// - Returns: NSManagedObjectContext
    func getMainContext() -> NSManagedObjectContext? {
        mainContext
    }
    
    /// Save a context
    /// - Parameter subContext: The context to save will check for changes and set it else will save the main context
    func saveContext(_ subContext: NSManagedObjectContext?) {
        guard let mainContext = mainContext else { return }
 
        guard let childContext = subContext else {
            mainContext.performAndWait { [weak self] in self?.saveMainContext() }
            return
        }
        
        if childContext.hasChanges {
            do {
                try childContext.save()
                mainContext.performAndWait { [weak self] in
                    self?.saveMainContext()
                }
            } catch {
                let nserror = error as NSError
                Log.error("Cannot save child context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// Will save the main context
    private func saveMainContext() {
        guard let mainContext = mainContext else { return }

        do {
            try mainContext.save()
        } catch {
            let nserror = error as NSError
            Log.error("Cannot save main context: \(nserror), \(nserror.userInfo)")
        }
    }
}

