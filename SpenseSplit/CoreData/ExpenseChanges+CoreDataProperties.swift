//
//  History+CoreDataProperties.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 29/3/24.
//

import Foundation
import CoreData


extension ChangeHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChangeHistory> {
        return NSFetchRequest<ChangeHistory>(entityName: "ChangeHistory")
    }

    @NSManaged public var who: String?
    @NSManaged public var when: Date
    @NSManaged public var expenseAnt: Expense?
    @NSManaged public var expensesPost: Expense?
    @NSManaged public var toParty: Party?
    
    public var wWho: String {
        get {who ?? ""}
        set {self.who = String(newValue)
            objectWillChange.send()
        }
    }
}

extension History : Identifiable {

}

