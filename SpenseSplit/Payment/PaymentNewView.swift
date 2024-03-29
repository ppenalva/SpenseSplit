//
//  PaymentNewView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 11/2/24.
//

import SwiftUI

struct PaymentNewView: View {
    
    @Binding var newPaymentName: String
    @Binding var newPaymentAmount: Double
    @Binding var newPaymentPayers: [Payer]
    @Binding var newPaymentEnjoyers: [Enjoyer]
    
    private let stack = CoreDataStack.shared
    
    @State private var isPresentingNewSendersView = false
    @State private var isPresentingNewReceiversView = false
    
    @State private var contadorSenders = 0
    @State private var contadorReceivers = 0
    
    var body: some View {
        List {
            Section(header: Text(" Payment Info")) {
                TextField("Description",text: $newPaymentName)
                TextField("Amount", value: $newPaymentAmount, format: .number)
            }
            HStack {
                HStack{
                Button ("Senders") {
                    
                    isPresentingNewSendersView = true
                }
                .buttonStyle(BorderlessButtonStyle())
                    Text(contadorSenders, format: .number)
                }
                Spacer()
                HStack{
                Button ("Receivers") {
                    
                    isPresentingNewReceiversView = true
                }
                .buttonStyle(BorderlessButtonStyle())
                    Text(contadorReceivers, format: .number)
                }
            }
            Section(header: Text("Senders")) {
                ForEach(newPaymentPayers) { payer in
                    if (payer.bandera) {
                        HStack{
                            Text(payer.toParticipant!.wName)
                            Spacer()
                            Text(String(format: "%.2f",payer.amount))
                        }
                    }
                }
            }
            Section(header: Text("Receivers")) {
                ForEach(newPaymentEnjoyers) { enjoyer in
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
            .sheet(isPresented: $isPresentingNewSendersView) {
                NavigationView {
                    SendersNewView(newPaymentName: $newPaymentName, newPaymentAmount: $newPaymentAmount,newPaymentPayers: $newPaymentPayers)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    for payer in newPaymentPayers {
                                        payer.bandera = false
                                    }
                                    isPresentingNewSendersView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    contadorSenders = 0
                                    for payer in newPaymentPayers {
                                        if (payer.bandera) {
                                            contadorSenders += 1
                                        }
                                    }
                                    isPresentingNewSendersView = false
                                }
                            }
                        }
                }
            }
            .sheet(isPresented: $isPresentingNewReceiversView) {
                NavigationView {
                    ReceiversNewView(newPaymentName: $newPaymentName, newPaymentAmount: $newPaymentAmount,newPaymentEnjoyers: $newPaymentEnjoyers)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    for enjoyer in newPaymentEnjoyers {
                                        enjoyer.bandera = false
                                    }
                                    isPresentingNewReceiversView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    contadorReceivers = 0
                                    for enjoyer in newPaymentEnjoyers {
                                        if (enjoyer.bandera) {
                                            contadorReceivers += 1
                                        }
                                    }
                                    isPresentingNewReceiversView = false
                                }
                            }
                        }
                }
            }
        }
    }

