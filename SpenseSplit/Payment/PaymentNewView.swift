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
    @Binding var validExpense: Bool
    @Binding var validPayment: Bool
    
    @State var theId: Int = 0
   
    private let stack = CoreDataStack.shared
    
    @State private var isPresentingNewSendersView = false
    @State private var isPresentingNewReceiversView = false
    
    @State private var contadorSenders = 0
    @State private var contadorReceivers = 0
    
    @State var validPayer = false
    @State var validEnjoyer = false
    
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
                        validPayer = false
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Text(contadorSenders, format: .number)
                }
                Spacer()
                HStack{
                    Button ("Receivers") {
                        
                        isPresentingNewReceiversView = true
                        validEnjoyer = false
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
                SendersNewView(newPaymentName: $newPaymentName, newPaymentAmount: $newPaymentAmount,newPaymentPayers: $newPaymentPayers, validPayer: $validPayer, validEnjoyer: $validEnjoyer, validExpense: $validExpense, validPayment: $validPayment, theId: $theId)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Reset") {
                                for payer in newPaymentPayers {
                                    payer.bandera = false
                                    payer.amount = 0.0
                                }
                                contadorSenders = 0
                                isPresentingNewSendersView = false
                                theId += 1
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Confirm") {
                                contadorSenders = 0
                                for payer in newPaymentPayers {
                                    if (payer.bandera) {
                                        contadorSenders += 1
                                    }
                                }
                                isPresentingNewSendersView = false
                                theId += 1
                            }
                            .disabled(!validPayer)
                        }
                    }
            }
        }
        .sheet(isPresented: $isPresentingNewReceiversView) {
            NavigationView {
                ReceiversNewView(newPaymentName: $newPaymentName, newPaymentAmount: $newPaymentAmount,newPaymentEnjoyers: $newPaymentEnjoyers, validPayer: $validPayer, validEnjoyer: $validEnjoyer, validExpense: $validExpense, validPayment: $validPayment, theId: $theId)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Reset") {
                                for enjoyer in newPaymentEnjoyers {
                                    enjoyer.bandera = false
                                    enjoyer.amount = 0.0
                                }
                                contadorReceivers = 0
                                isPresentingNewReceiversView = false
                                theId += 1
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Confirm") {
                                contadorReceivers = 0
                                for enjoyer in newPaymentEnjoyers {
                                    if (enjoyer.bandera) {
                                        contadorReceivers += 1
                                    }
                                }
                                isPresentingNewReceiversView = false
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
