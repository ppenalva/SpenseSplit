//
//  HistoryView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 30/3/24.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var party: Party
    
    var body: some View {
        
        List {
            HStack{
                Text("Party: ")
                Text(party.wName)
            }
            Section(header:
                        Text("Expenses")) {
                ForEach(party.expenseChangesArray) { expenseChange in
                    HStack {
                        Text(expenseChange.when, style:  .date)
                        Text(expenseChange.when, style:  .time)
                    }
                    Text("Before")
                    HStack {
                        Text(expenseChange.before!.wName)
                        Spacer()
                        Text(String(format: "%.2f",expenseChange.before!.amount))
                    }
                    Section(header: Text("Payers")) {
                        ForEach(expenseChange.before!.payersLogArray) { payer in
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
                    ForEach(expenseChange.before!.enjoyersLogArray) { enjoyer in
                        if (enjoyer.bandera) {
                            HStack{
                            Text(enjoyer.toParticipant!.wName)
                                Spacer()
                            Text(String(format: "%.2f",enjoyer.amount))
                            }
                        }
                    }
                }
                    Text("After")
                    HStack {
                        Text(expenseChange.after!.wName)
                        Spacer()
                        Text(String(format: "%.2f",expenseChange.after!.amount))
                    }
                    Section(header: Text("Payers")) {
                        ForEach(expenseChange.after!.payersLogArray) { payer in
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
                    ForEach(expenseChange.after!.enjoyersLogArray) { enjoyer in
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
            Section(header:
                        Text("Payments")) {
                ForEach(party.paymentChangesArray) { paymentChange in
                    HStack {
                        Text(paymentChange.when, style:  .date)
                        Text(paymentChange.when, style:  .time)
                    }
                    Text("Before")
                    HStack {
                        Text(paymentChange.before!.wName)
                        Spacer()
                        Text(String(format: "%.2f",paymentChange.before!.amount))
                    }
                    Section(header: Text("Payers")) {
                        ForEach(paymentChange.before!.payersLogArray) { payer in
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
                    ForEach(paymentChange.before!.enjoyersLogArray) { enjoyer in
                        if (enjoyer.bandera) {
                            HStack{
                            Text(enjoyer.toParticipant!.wName)
                                Spacer()
                            Text(String(format: "%.2f",enjoyer.amount))
                            }
                        }
                    }
                }
                    Text("After")
                    HStack {
                        Text(paymentChange.after!.wName)
                        Spacer()
                        Text(String(format: "%.2f",paymentChange.after!.amount))
                    }
                    Section(header: Text("Payers")) {
                        ForEach(paymentChange.after!.payersLogArray) { payer in
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
                    ForEach(paymentChange.after!.enjoyersLogArray) { enjoyer in
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
    }
}
