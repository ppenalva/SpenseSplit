//
//  Expense+CoreDataProperties.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: Double
    @NSManaged public var toParty: Party?
    @NSManaged public var payers: NSSet?
    @NSManaged public var enjoyers: NSSet?
    @NSManaged public var expenseChanges: NSSet?
    
    public var wName: String {
        get {name ?? ""}
        set {self.name = String(newValue)
            objectWillChange.send()
        }
    }
    public var payersArray: [Payer] {
        get {let set = payers as? Set<Payer> ?? []
            return set.sorted {
                $0.toParticipant!.wName < $1.toParticipant!.wName}
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
                $0.toParticipant!.wName < $1.toParticipant!.wName}
        }
        set {
                self.enjoyers = Set<Enjoyer>() as NSSet
            
            for (element) in newValue {
                self.enjoyers = NSSet(set: self.enjoyers!.adding(element))
                objectWillChange.send()
            }
        }
    }
    public var expenseChangesArray: [ExpenseChanges] {
        get {let set = expenseChanges as? Set<ExpenseChanges> ?? []
            return set.sorted {
                $0.when! < $1.when!}
        }
        set {
                self.expenseChanges = Set<ExpenseChanges>() as NSSet
            
            for (element) in newValue {
                self.expenseChanges = NSSet(set: self.expenseChanges!.adding(element))
                objectWillChange.send()
            }
        }
    }
}
extension Expense : Identifiable {
}
