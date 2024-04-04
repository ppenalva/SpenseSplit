//
//  PaymentDispalyView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 1/4/24.
//

import SwiftUI
import CoreData

struct PaymentDisplayView: View {
    
    @ObservedObject var payment: Payment
    
    var body: some View {
        List {
            Section(header: Text(" Payment Info")) {
                Text("Description :  \(payment.wName)")
                Text("Amount: \(payment.amount, format: .number))")
            }
            Section(header:Text("Payers")) {
                ForEach(payment.payersArray) { payer in
                    if (payer.bandera) {
                        HStack{
                            Text(payer.toParticipant!.wName)
                            Spacer()
                            Text(String(format: "%.2f",payer.amount))
                        }
                    }
                }
            }
            Section(header: Text("Enjoyers")) {
                ForEach(payment.enjoyersArray) { enjoyer in
                    if (enjoyer.bandera) {
                        HStack{
                            Text(enjoyer.toParticipant!.wName)
                            Spacer()
                            Text(String(format: "%.2f",enjoyer.amount))
                        }
                    }
                }
            }
        }
    }
}

