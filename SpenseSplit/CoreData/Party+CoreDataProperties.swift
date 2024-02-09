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
    
    public var wrappedName: String {
        get {name ?? ""}
        set {self.name = String(newValue)
            objectWillChange.send()
        }
    }
    public var wrappedTheme: String {
        get {theme ?? ""}
        set {self.theme = String(newValue)
            objectWillChange.send()
        }
    }
    public var participantsArray: [Participant] {
        let set = participants as? Set<Participant> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var expensesArray: [Expense] {
        let set = expenses as? Set<Expense> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

extension Party : Identifiable {

}
