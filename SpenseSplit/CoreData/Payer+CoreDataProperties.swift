//
//  Payer+CoreDataProperties.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import Foundation
import CoreData


extension Payer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Payer> {
        return NSFetchRequest<Payer>(entityName: "Payer")
    }

    @NSManaged public var name: String?
    @NSManaged public var toParticipant: Participant?
    @NSManaged public var toParty: Party?
    
    public var wrappedName: String {
        get {name ?? ""}
        set {self.name = String(newValue)
            objectWillChange.send()
        }
    }
}

extension Payer : Identifiable {

}
