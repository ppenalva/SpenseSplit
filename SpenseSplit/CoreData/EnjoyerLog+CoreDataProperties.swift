//
//  EnjoyerLog+CoreDataProperties.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 31/3/24.
//

import Foundation
import CoreData


extension EnjoyerLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EnjoyerLog> {
        return NSFetchRequest<EnjoyerLog>(entityName: "EnjoyerLog")
    }
    @NSManaged public var bandera: Bool
    @NSManaged public var amount: Double
    @NSManaged public var toParticipant: Participant?
    @NSManaged public var toExpenseLog: ExpenseLog?
    @NSManaged public var toPaymentLog: PaymentLog?
}

extension EnjoyerLog : Identifiable {

}
