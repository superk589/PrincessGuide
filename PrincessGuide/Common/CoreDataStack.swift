//
//  CoreDataStack.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/2.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let `default` = CoreDataStack()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentCloudKitContainer(name: "PrincessGuide")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var coordinator: NSPersistentStoreCoordinator = {
        return self.container.persistentStoreCoordinator
    }()
    
    private(set) lazy var viewContext: NSManagedObjectContext = {
        self.container.viewContext.automaticallyMergesChangesFromParent = true
        return self.container.viewContext
    }()
    
    func newChildContext(parent: NSManagedObjectContext, concurrencyType: NSManagedObjectContextConcurrencyType? = nil) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: concurrencyType ?? parent.concurrencyType)
        context.parent = parent
        return context
    }
    
}
