//
//  PaymentDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 11/2/24.
//

import SwiftUI

struct PaymentDetailView: View {
    
    @ObservedObject var payment: Payment
    
    @State private var isPresentingDetailSendersView = false
    @State private var isPresentingDetailReceiversView = false
    
    
    var body: some View {
        List {
            Section(header: Text(" Payment Info")) {
                TextField("Description",text: $payment.wName)
                TextField("Amount", value: $payment.amount, format: .number)
            }
            HStack {
                Button ("Senders") {
                    
                    isPresentingDetailSendersView = true
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
                Button ("Receivers") {
                    
                    isPresentingDetailReceiversView = true
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            Section(header: Text("Senders")) {
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
            Section(header: Text("Receivers")) {
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
            .sheet(isPresented: $isPresentingDetailSendersView) {
                NavigationView {
                    SendersDetailView(payment: payment)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingDetailSendersView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    isPresentingDetailSendersView = false
                                }
                            }
                        }
                }
            }
            .sheet(isPresented: $isPresentingDetailReceiversView) {
                NavigationView {
                    ReceiversDetailView(payment: payment)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingDetailReceiversView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    isPresentingDetailReceiversView = false
                                }
                            }
                        }
                }
            }
            
        }
    }

