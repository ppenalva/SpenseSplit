//
//  CoreDataStack.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import CloudKit
import CoreData
//import Foundation


final class CoreDataStack {
    static let shared = CoreDataStack()

    init() {}

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "SpenseSplit")

        let dbURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let privateDesc = NSPersistentStoreDescription(url: dbURL.appendingPathComponent("model.sqlite"))
        privateDesc.configuration = "Private"
        privateDesc.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: ckContainerID)
        privateDesc.cloudKitContainerOptions?.databaseScope = .private

        guard let shareDesc = privateDesc.copy() as? NSPersistentStoreDescription else {
            fatalError("Create shareDesc error")
        }
        shareDesc.url = dbURL.appendingPathComponent("share.sqlite")
        let shareDescOption = NSPersistentCloudKitContainerOptions(containerIdentifier: ckContainerID)
        shareDescOption.databaseScope = .shared
        shareDesc.cloudKitContainerOptions = shareDescOption

        container.persistentStoreDescriptions = [privateDesc, shareDesc]

        container.loadPersistentStores(completionHandler: { desc, err in
            if let err = err as NSError? {
                fatalError("DB init error:\(err.localizedDescription)")
            } else if let cloudKitContiainerOptions = desc.cloudKitContainerOptions {
                switch cloudKitContiainerOptions.databaseScope {
                case .private:
                    self._privatePersistentStore = container.persistentStoreCoordinator.persistentStore(for: privateDesc.url!)
                case .shared:
                    self._sharedPersistentStore = container.persistentStoreCoordinator.persistentStore(for: shareDesc.url!)
                default:
                    break
                }
            }
        })

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("Fail to pin viewContext to the current generation:\(error)")
        }

        return container
    }()

    let ckContainerID = "iCloud.com.pablo.penalva.spenseSplit"

    var ckContainer: CKContainer {
        CKContainer(identifier: ckContainerID)
    }

    private var _privatePersistentStore: NSPersistentStore?
    var privatePersistentStore: NSPersistentStore {
        return _privatePersistentStore!
    }

    private var _sharedPersistentStore: NSPersistentStore?
    var sharedPersistentStore: NSPersistentStore {
        return _sharedPersistentStore!
    }

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}

extension CoreDataStack {
    func isShared(objectID: NSManagedObjectID) -> Bool {
        var isShared = false
        if let persistentStore = objectID.persistentStore {
            if persistentStore == sharedPersistentStore {
                isShared = true
            } else {
                let container = persistentContainer
                do {
                    let shares = try container.fetchShares(matching: [objectID])
                    if shares.first != nil {
                        isShared = true
                    }
                } catch {
                    print("Failed to fetch share for \(objectID): \(error)")
                }
            }
        }
        return isShared
    }

    func isShared(object: NSManagedObject) -> Bool {
        isShared(objectID: object.objectID)
    }

    func canEdit(object: NSManagedObject) -> Bool {
        return persistentContainer.canUpdateRecord(forManagedObjectWith: object.objectID)
    }

    func canDelete(object: NSManagedObject) -> Bool {
        return persistentContainer.canDeleteRecord(forManagedObjectWith: object.objectID)
    }

    func isOwner(object: NSManagedObject) -> Bool {
        guard isShared(object: object) else { return false }
        guard let share = try? persistentContainer.fetchShares(matching: [object.objectID])[object.objectID] else {
            print("Get ckshare error")
            return false
        }
        if let currentUser = share.currentUserParticipant, currentUser == share.owner {
            return true
        }
        return false
    }

    func getShare(_ party: Party) -> CKShare? {
        guard isShared(object: party) else { return nil }
        guard let share = try? persistentContainer.fetchShares(matching: [party.objectID])[party.objectID] else {
            print("Get ckshare error")
            return nil
        }
        share[CKShare.SystemFieldKey.title] = party.name
        return share
    }
}

extension CoreDataStack {
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("ViewContext save error:\(error)")
            }
        }
    }
    
    func delShare(_ share: CKShare?) async {
        guard let share = share else { return }
        do {
            try await ckContainer.privateCloudDatabase.deleteRecord(withID: share.recordID)
        } catch {
            print("Failed to delete ckshare in icloud, error: \(error)")
        }
    }
}
