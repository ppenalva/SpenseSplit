//
//  Payment+CoreDataProperties.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 11/2/24.
//

import Foundation
import CoreData


extension Payment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Payment> {
        return NSFetchRequest<Payment>(entityName: "Payment")
    }

    @NSManaged public var name: String?
    @NSManaged public var amount: Double
    @NSManaged public var toParty: Party?
    @NSManaged public var payers: NSSet?
    @NSManaged public var enjoyers: NSSet?
    @NSManaged public var paymentChanges: NSSet?
    
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
    public var paymentChangesArray: [PaymentChanges] {
        get {let set = paymentChanges as? Set<PaymentChanges> ?? []
            return set.sorted {
                $0.when! < $1.when!}
        }
        set {
                self.paymentChanges = Set<PaymentChanges>() as NSSet
            
            for (element) in newValue {
                self.paymentChanges = NSSet(set: self.paymentChanges!.adding(element))
                objectWillChange.send()
            }
        }
    }
}
extension Payment : Identifiable {
}
