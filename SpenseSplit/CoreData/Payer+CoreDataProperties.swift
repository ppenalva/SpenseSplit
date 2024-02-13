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
    @NSManaged public var bandera: Bool
    @NSManaged public var amount: Double
    @NSManaged public var toParticipant: Participant?
    @NSManaged public var toExpense: Expense?
    @NSManaged public var toPayemnt: Payment?
}
extension Payer : Identifiable {

}
