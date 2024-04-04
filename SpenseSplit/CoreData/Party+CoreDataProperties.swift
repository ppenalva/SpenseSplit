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
    @NSManaged public var expenseChanges: NSSet?
    @NSManaged public var paymentChanges: NSSet?
    @NSManaged public var expensesLog: NSSet?
    @NSManaged public var paymentsLog: NSSet?
    
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
    public var expenseChangesArray: [ExpenseChanges] {
        get {let set = expenseChanges as? Set<ExpenseChanges> ?? []
            return set.sorted {
                $0.when < $1.when}
        }
        set {
                self.expenseChanges = Set<ExpenseChanges>() as NSSet
            
            for (element) in newValue {
                self.expenseChanges = NSSet(set: self.expenseChanges!.adding(element))
                objectWillChange.send()
            }
        }
    }
    public var paymentChangesArray: [PaymentChanges] {
        get {let set = paymentChanges as? Set<PaymentChanges> ?? []
            return set.sorted {
                $0.when < $1.when}
        }
        set {
                self.paymentChanges = Set<PaymentChanges>() as NSSet
            
            for (element) in newValue {
                self.paymentChanges = NSSet(set: self.paymentChanges!.adding(element))
                objectWillChange.send()
            }
        }
    }
    public var expensesLogArray: [ExpenseLog] {
        get {let set = expensesLog as? Set<ExpenseLog> ?? []
            return set.sorted {
                $0.wName < $1.wName}
        }
        set {
                self.expensesLog = Set<ExpenseLog>() as NSSet
            
            for (element) in newValue {
                self.expensesLog = NSSet(set: self.expensesLog!.adding(element))
                objectWillChange.send()
            }
        }
    }
    public var paymentsLogArray: [PaymentLog] {
        get {let set = paymentsLog as? Set<PaymentLog> ?? []
            return set.sorted {
                $0.wName < $1.wName}
        }
        set {
                self.paymentsLog = Set<PaymentLog>() as NSSet
            
            for (element) in newValue {
                self.paymentsLog = NSSet(set: self.paymentsLog!.adding(element))
                objectWillChange.send()
            }
        }
    }
}
extension Party : Identifiable {
}
