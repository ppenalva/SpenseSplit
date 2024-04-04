//
//  ExpenseDispayView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 31/3/24.
//

import SwiftUI
import CoreData

struct ExpenseDisplayView: View {
    
    @ObservedObject var expense: Expense
    
    var body: some View {
        List {
            Section(header: Text(" Expense Info")) {
                Text("Description :  \(expense.wName)")
                Text("Amount: \(expense.amount, format: .number))")
            }
            Section(header:Text("Payers")) {
                ForEach(expense.payersArray) { payer in
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
                ForEach(expense.enjoyersArray) { enjoyer in
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

