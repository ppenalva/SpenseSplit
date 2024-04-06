//
//  PaymentChanges+CoreDataProperties.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 30/3/24.
//

import Foundation
import CoreData


extension PaymentChanges {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaymentChanges> {
        return NSFetchRequest<PaymentChanges>(entityName: "PaymentChanges")
    }

    @NSManaged public var who: String?
    @NSManaged public var when: Date?
    @NSManaged public var before: PaymentLog?
    @NSManaged public var after: PaymentLog?
    @NSManaged public var toParty: Party?
    @NSManaged public var toPayment: Payment?
    
    public var wWho: String {
        get {who ?? ""}
        set {self.who = String(newValue)
            objectWillChange.send()
        }
    }
}

extension PaymentChanges : Identifiable {

}

