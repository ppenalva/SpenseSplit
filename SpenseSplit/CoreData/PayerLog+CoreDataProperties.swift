//
//  PayerLog+CoreDataProperties.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 31/3/24.
//

import Foundation
import CoreData


extension PayerLog {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PayerLog> {
        return NSFetchRequest<PayerLog>(entityName: "PayerLog")
    }
    @NSManaged public var bandera: Bool
    @NSManaged public var amount: Double
    @NSManaged public var toParticipant: Participant?
    @NSManaged public var toExpenseLog: ExpenseLog?
    @NSManaged public var toPaymentLog: PaymentLog?
}
extension PayerLog : Identifiable {

}
