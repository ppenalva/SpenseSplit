//
//  History+CoreDataProperties.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 29/3/24.
//

import Foundation
import CoreData


extension ExpenseChanges {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseChanges> {
        return NSFetchRequest<ExpenseChanges>(entityName: "ExpenseChanges")
    }

    @NSManaged public var who: String?
    @NSManaged public var when: Date
    @NSManaged public var before: ExpenseLog?
    @NSManaged public var after: ExpenseLog?
    @NSManaged public var toParty: Party?
    @NSManaged public var toExpense: Expense?
    
    public var wWho: String {
        get {who ?? ""}
        set {self.who = String(newValue)
            objectWillChange.send()
        }
    }
}

extension ExpenseChanges : Identifiable {

}

