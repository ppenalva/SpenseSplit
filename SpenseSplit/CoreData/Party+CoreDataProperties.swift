//
//  Party+CoreDataProperties.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import Foundation
import CoreData


extension Party {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Party> {
        return NSFetchRequest<Party>(entityName: "Party")
    }

    @NSManaged public var name: String?
    @NSManaged public var theme: String?
    @NSManaged public var participants: NSSet?
    @NSManaged public var expenses: NSSet?
    @NSManaged public var payments: NSSet?
    
    public var wName: String {
        get {name ?? ""}
        set {self.name = String(newValue)
            objectWillChange.send()
        }
    }
    public var wTheme: String {
        get {theme ?? ""}
        set {self.theme = String(newValue)
            objectWillChange.send()
        }
    }
    public var participantsArray: [Participant] {
        get {let set = participants as? Set<Participant> ?? []
            return set.sorted {
                $0.wName < $1.wName}
        }
        set {
                self.participants = Set<Participant>() as NSSet
            
            for (element) in newValue {
                self.participants = NSSet(set: self.participants!.adding(element))
                objectWillChange.send()
            }
        }
    }
    public var expensesArray: [Expense] {
        get {let set = expenses as? Set<Expense> ?? []
            return set.sorted {
                $0.wName < $1.wName}
        }
        set {
                self.expenses = Set<Expense>() as NSSet
            
            for (element) in newValue {
                self.expenses = NSSet(set: self.expenses!.adding(element))
                objectWillChange.send()
            }
        }
    }
    public var paymentsArray: [Payment] {
        get {let set = payments as? Set<Payment> ?? []
            return set.sorted {
                $0.wName < $1.wName}
        }
        set {
                self.payments = Set<Payment>() as NSSet
            
            for (element) in newValue {
                self.payments = NSSet(set: self.payments!.adding(element))
                objectWillChange.send()
            }
        }
    }
}

extension Party : Identifiable {

}
