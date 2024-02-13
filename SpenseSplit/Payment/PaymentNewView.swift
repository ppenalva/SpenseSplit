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
    
    @State var newPaymentPayers1: [Payer] = []
    @State var newPaymentEnjoyers1: [Enjoyer] = []
    
    private let stack = CoreDataStack.shared
    
    @State private var isPresentingNewSendersView = false
    @State private var isPresentingNewReceiversView = false
    
    var body: some View {
        List {
            Section(header: Text(" Payment Info")) {
                TextField("Description",text: $newPaymentName)
                TextField("Amount", value: $newPaymentAmount, format: .number)
            }
            HStack {
                Button ("Senders") {
                    
                    isPresentingNewSendersView = true
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
                Button ("Receivers") {
                    
                    isPresentingNewReceiversView = true
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            Section(header: Text("Senders")) {
                ForEach($newPaymentPayers1) { $payer in
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
                ForEach($newPaymentEnjoyers1) { $enjoyer in
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
                    SendersNewView(newPaymentPayers: $newPaymentPayers)
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
                                    newPaymentPayers1 = newPaymentPayers
                                    isPresentingNewSendersView = false
                                }
                            }
                        }
                }
            }
            .sheet(isPresented: $isPresentingNewReceiversView) {
                NavigationView {
                    ReceiversNewView(newPaymentEnjoyers: $newPaymentEnjoyers)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    for payer in newPaymentPayers {
                                        payer.bandera = false
                                    }
                                    isPresentingNewReceiversView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    newPaymentEnjoyers1 = newPaymentEnjoyers
                                    isPresentingNewReceiversView = false
                                }
                            }
                        }
                }
            }
        }
    }

