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
    @Binding var validExpense: Bool
    @Binding var validPayment: Bool
    
    @State var theId: Int = 0
    
    private let stack = CoreDataStack.shared
    
    @State private var isPresentingNewPayersView = false
    @State private var isPresentingNewEnjoyersView = false
    
    @State private var contadorPayers = 0
    @State private var contadorEnjoyers = 0
    
    @State var validPayer = false
    @State var validEnjoyer = false
    
    var body: some View {
        List {
            Section(header: Text(" Expense Info")) {
                TextField("Description",text: $newExpenseName)
                TextField("Amount", value: $newExpenseAmount, format: .number)
            }
            HStack {
                HStack{
                    Button ("Payers") {
                        
                        isPresentingNewPayersView = true
                        validPayer = false
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Text(contadorPayers, format: .number)
                }
                Spacer()
                HStack{
                    Button ("Enjoyers") {
                        
                        isPresentingNewEnjoyersView = true
                        validEnjoyer = false
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Text(contadorEnjoyers, format: .number)
                }
            }
            Section(header: Text("Payers")) {
                ForEach(newExpensePayers) { payer in
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
                ForEach(newExpenseEnjoyers) { enjoyer in
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
                PayersNewView(newExpenseName: $newExpenseName, newExpenseAmount: $newExpenseAmount,newExpensePayers: $newExpensePayers, validPayer: $validPayer, validEnjoyer: $validEnjoyer, validExpense: $validExpense, validPayment: $validPayment, theId: $theId)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Reset") {
                                for payer in newExpensePayers {
                                    payer.bandera = false
                                    payer.amount = 0.0
                                }
                                contadorPayers = 0
                                isPresentingNewPayersView = false
                                validPayer = false
                                theId += 1
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Confirm") {
                                contadorPayers = 0
                                for payer in newExpensePayers {
                                    if (payer.bandera) {
                                        contadorPayers += 1
                                    }
                                }
                                isPresentingNewPayersView = false
                                theId += 1
                            }
                            .disabled(!validPayer)
                        }
                    }
            }
        }
        .sheet(isPresented: $isPresentingNewEnjoyersView) {
            NavigationView {
                EnjoyersNewView(newExpenseName: $newExpenseName, newExpenseAmount: $newExpenseAmount,newExpenseEnjoyers: $newExpenseEnjoyers, validPayer: $validPayer, validEnjoyer: $validEnjoyer, validExpense: $validExpense, validPayment: $validPayment, theId: $theId)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Reset") {
                                for enjoyer in newExpenseEnjoyers {
                                    enjoyer.bandera = false
                                    enjoyer.amount = 0.0
                                }
                                contadorEnjoyers = 0
                                isPresentingNewEnjoyersView = false
                                validEnjoyer = false
                                theId += 1
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Confirm") {
                                contadorEnjoyers = 0
                                for enjoyer in newExpenseEnjoyers {
                                    if (enjoyer.bandera) {
                                        contadorEnjoyers += 1
                                    }
                                }
                                isPresentingNewEnjoyersView = false
                                theId += 1
                            }
                            .disabled(!validEnjoyer)
                        }
                    }
            }
        }
        .id(theId)
    }
}

