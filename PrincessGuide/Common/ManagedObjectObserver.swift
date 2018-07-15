//
//  ManagedObjectObserver.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/15.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import CoreData

public final class ManagedObjectObserver {
    
    public enum ChangeType {
        case delete
        case update
    }
    
    public init?(object: NSManagedObject, changeHandler: @escaping (ChangeType) -> ()) {
        guard let moc = object.managedObjectContext else { return nil }
        token = moc.addObjectsDidChangeNotificationObserver { [unowned self] note in
            guard let changeType = self.changeType(of: object, in: note) else { return }
            self.objectHasBeenDeleted = changeType == .delete
            changeHandler(changeType)
        }
    }
    
    // MARK: Private
    
    private var token: NSObjectProtocol!
    private var objectHasBeenDeleted: Bool = false
    
    fileprivate func changeType(of object: NSManagedObject, in note: ObjectsDidChangeNotification) -> ChangeType? {
        let deleted = note.deletedObjects.union(note.invalidatedObjects)
        if note.invalidatedAllObjects || deleted.containsObjectIdentical(to: object) {
            return .delete
        }
        let updated = note.updatedObjects.union(note.refreshedObjects)
        if updated.containsObjectIdentical(to: object) {
            return .update
        }
        return nil
    }
}

public struct ObjectsDidChangeNotification {
    
    init(note: Notification) {
        assert(note.name == .NSManagedObjectContextObjectsDidChange)
        notification = note
    }
    
    public var insertedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInsertedObjectsKey)
    }
    
    public var updatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSUpdatedObjectsKey)
    }
    
    public var deletedObjects: Set<NSManagedObject> {
        return objects(forKey: NSDeletedObjectsKey)
    }
    
    public var refreshedObjects: Set<NSManagedObject> {
        return objects(forKey: NSRefreshedObjectsKey)
    }
    
    public var invalidatedObjects: Set<NSManagedObject> {
        return objects(forKey: NSInvalidatedObjectsKey)
    }
    
    public var invalidatedAllObjects: Bool {
        return (notification as Notification).userInfo?[NSInvalidatedAllObjectsKey] != nil
    }
    
    public var managedObjectContext: NSManagedObjectContext {
        guard let c = notification.object as? NSManagedObjectContext else { fatalError("Invalid notification object") }
        return c
    }
    
    // MARK: Private
    
    fileprivate let notification: Notification
    
    fileprivate func objects(forKey key: String) -> Set<NSManagedObject> {
        return ((notification as Notification).userInfo?[key] as? Set<NSManagedObject>) ?? Set()
    }
    
}

extension NSManagedObjectContext {
    
    /// Adds the given block to the default `NotificationCenter`'s dispatch table for the given context's objects-did-change notifications.
    /// - returns: An opaque object to act as the observer. This must be sent to the default `NotificationCenter`'s `removeObserver()`.
    public func addObjectsDidChangeNotificationObserver(_ handler: @escaping (ObjectsDidChangeNotification) -> ()) -> NSObjectProtocol {
        let nc = NotificationCenter.default
        return nc.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: self, queue: nil) { note in
            let wrappedNote = ObjectsDidChangeNotification(note: note)
            handler(wrappedNote)
        }
    }
    
}

extension Sequence where Self.Element: AnyObject {
    public func containsObjectIdentical(to object: AnyObject) -> Bool {
        return contains { $0 === object }
    }
}
