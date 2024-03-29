//
//  Participant+CoreDataProperties.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import Foundation
import CoreData


extension Participant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Participant> {
        return NSFetchRequest<Participant>(entityName: "Participant")
    }

    @NSManaged public var name: String?
    @NSManaged public var toParty: Party?
    @NSManaged public var payers: NSSet?
    @NSManaged public var enjoyers: NSSet?
    
    public var wName: String {
        get {name ?? ""}
        set {self.name = String(newValue)
            objectWillChange.send()
        }
    }
    public var payersArray: [Payer] {
        get {let set = payers as? Set<Payer> ?? []
            return set.sorted {
                $0.amount < $1.amount}
        }
        set {
                self.payers = Set<Payer>() as NSSet
            
            for (element) in newValue {
                self.payers = NSSet(set: self.payers!.adding(element))
                objectWillChange.send()
            }
        }
    }
    public var enjoyersArray: [Enjoyer] {
        get {let set = enjoyers as? Set<Enjoyer> ?? []
            return set.sorted {
                $0.amount < $1.amount}
        }
        set {
                self.enjoyers = Set<Enjoyer>() as NSSet
            
            for (element) in newValue {
                self.enjoyers = NSSet(set: self.enjoyers!.adding(element))
                objectWillChange.send()
            }
        }
    }
}

extension Participant : Identifiable {

}
