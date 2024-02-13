//
//  ExpenseNewView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 11/2/24.
//

import SwiftUI

struct ExpenseNewView: View {
    
    @Binding var newExpenseName: String
    @Binding var newExpenseAmount: Double
    @Binding var newExpensePayers: [Payer]
    @Binding var newExpenseEnjoyers: [Enjoyer]
    
    @State var newExpensePayers1: [Payer] = []
    @State var newExpenseEnjoyers1: [Enjoyer] = []
    
    private let stack = CoreDataStack.shared
    
    @State private var isPresentingNewPayersView = false
    @State private var isPresentingNewEnjoyersView = false
    
    var body: some View {
        List {
            Section(header: Text(" Expense Info")) {
                TextField("Description",text: $newExpenseName)
                TextField("Amount", value: $newExpenseAmount, format: .number)
            }
            HStack {
                Button ("Payers") {
                    
                    isPresentingNewPayersView = true
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
                Button ("Enjoyers") {
                    
                    isPresentingNewEnjoyersView = true
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            Section(header: Text("Payers")) {
                ForEach($newExpensePayers1) { $payer in
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
                ForEach($newExpenseEnjoyers1) { $enjoyer in
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
            .sheet(isPresented: $isPresentingNewPayersView) {
                NavigationView {
                    PayersNewView(newExpensePayers: $newExpensePayers)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    for payer in newExpensePayers {
                                        payer.bandera = false
                                    }
                                    isPresentingNewPayersView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    newExpensePayers1 = newExpensePayers
                                    isPresentingNewPayersView = false
                                }
                            }
                        }
                }
            }
            .sheet(isPresented: $isPresentingNewEnjoyersView) {
                NavigationView {
                    EnjoyersNewView(newExpenseEnjoyers: $newExpenseEnjoyers)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    for payer in newExpensePayers {
                                        payer.bandera = false
                                    }
                                    isPresentingNewEnjoyersView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    newExpenseEnjoyers1 = newExpenseEnjoyers
                                    isPresentingNewEnjoyersView = false
                                }
                            }
                        }
                }
            }
        }
    }

