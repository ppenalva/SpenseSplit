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
    @NSManaged public var payers: NSSet?
    @NSManaged public var enjoyers: NSSet?
    
    public var wrappedName: String {
        get {name ?? ""}
        set {self.name = String(newValue)
            objectWillChange.send()
        }
    }
    public var payersArray: [Payer] {
        let set = payers as? Set<Payer> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var enjoyersArray: [Enjoyer] {
        let set = enjoyers as? Set<Enjoyer> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

extension Expense : Identifiable {

}
