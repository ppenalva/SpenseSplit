//
//  ExpenseLog+CoreDataProperties.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 30/3/24.
//

import Foundation
import CoreData


extension ExpenseLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseLog> {
        return NSFetchRequest<ExpenseLog>(entityName: "ExpenseLog")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: Double
    @NSManaged public var toParty: Party?
    @NSManaged public var payersLog: NSSet?
    @NSManaged public var enjoyersLog: NSSet?
    @NSManaged public var befores: NSSet?
    @NSManaged public var afters: NSSet?
    
    public var wName: String {
        get {name ?? ""}
        set {self.name = String(newValue)
            objectWillChange.send()
        }
    }
    public var payersLogArray: [PayerLog] {
        get {let set = payersLog as? Set<PayerLog> ?? []
            return set.sorted {
                $0.toParticipant!.wName < $1.toParticipant!.wName}
        }
        set {
                self.payersLog = Set<PayerLog>() as NSSet
            
            for (element) in newValue {
                self.payersLog = NSSet(set: self.payersLog!.adding(element))
                objectWillChange.send()
            }
        }
    }
    public var enjoyersLogArray: [EnjoyerLog] {
        get {let set = enjoyersLog as? Set<EnjoyerLog> ?? []
            return set.sorted {
                $0.toParticipant!.wName < $1.toParticipant!.wName}
        }
        set {
                self.enjoyersLog = Set<EnjoyerLog>() as NSSet
            
            for (element) in newValue {
                self.enjoyersLog = NSSet(set: self.enjoyersLog!.adding(element))
                objectWillChange.send()
            }
        }
    }
    public var beforesArray: [ExpenseChanges] {
        get {let set = befores as? Set<ExpenseChanges> ?? []
            return set.sorted {
                $0.when < $1.when}
        }
        set {
                self.befores = Set<ExpenseChanges>() as NSSet
            
            for (element) in newValue {
                self.befores = NSSet(set: self.befores!.adding(element))
                objectWillChange.send()
            }
        }
    }
    public var aftersArray: [ExpenseChanges] {
        get {let set = afters as? Set<ExpenseChanges> ?? []
            return set.sorted {
                $0.when < $1.when}
        }
        set {
                self.afters = Set<ExpenseChanges>() as NSSet
            
            for (element) in newValue {
                self.afters = NSSet(set: self.afters!.adding(element))
                objectWillChange.send()
            }
        }
    }
}
extension ExpenseLog : Identifiable {
}
