//
//  ExpenseDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 11/2/24.
//

import SwiftUI

struct ExpenseDetailView: View {
    
    @ObservedObject var expense: Expense
    
    @State private var isPresentingDetailPayersView = false
    @State private var isPresentingDetailEnjoyersView = false
    
    
    var body: some View {
        List {
            Section(header: Text(" Expense Info")) {
                TextField("Description",text: $expense.wName)
                TextField("Amount", value: $expense.amount, format: .number)
            }
            HStack {
                Button ("Payers") {
                    
                    isPresentingDetailPayersView = true
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
                Button ("Enjoyers") {
                    
                    isPresentingDetailEnjoyersView = true
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            Section(header: Text("Payers")) {
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
            .sheet(isPresented: $isPresentingDetailPayersView) {
                NavigationView {
                    PayersDetailView(expense: expense)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingDetailPayersView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    isPresentingDetailPayersView = false
                                }
                            }
                        }
                }
            }
            .sheet(isPresented: $isPresentingDetailEnjoyersView) {
                NavigationView {
                    EnjoyersDetailView(expense: expense)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingDetailEnjoyersView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    isPresentingDetailEnjoyersView = false
                                }
                            }
                        }
                }
            }
            
        }
    }

