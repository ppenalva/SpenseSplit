//
//  PaymentDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 11/2/24.
//

import SwiftUI
import CoreData


struct PaymentDetailView: View {
    
    @Binding var payment: Payment
    @Binding var theId: Int
    
    private let stack = CoreDataStack.shared
    
    @State private var isPresentingDetailSendersView = false
    @State private var isPresentingDetailReceiversView = false
    
    struct PayerEnjoyer {
        var bandera: Bool
        var amount: Double
        var toParticipant: Participant
    }
    
    @State private var paymentBeforeName = ""
    @State private var paymentBeforeAmount = 0.0
    @State private var paymentBeforePayers: [PayerEnjoyer] = []
    @State private var paymentBeforeEnjoyers: [PayerEnjoyer] = []
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var btnBack : some View { Button(action: {
        theId += 1
        createHistory()
        self.presentationMode.wrappedValue.dismiss()
    }) {
        Text(payment.toParty!.wName)
    }
    }
    
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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
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
        .onAppear(perform: keepInitial)
    }
    func keepInitial() {

        paymentBeforeName = payment.wName
        paymentBeforeAmount = payment.amount
        for payer in payment.payersArray {
            let a = PayerEnjoyer(bandera: payer.bandera, amount: payer.amount, toParticipant: payer.toParticipant!)
            paymentBeforePayers.append(a)
        }
        for enjoyer in payment.enjoyersArray {
            let a = PayerEnjoyer(bandera: enjoyer.bandera, amount: enjoyer.amount, toParticipant: enjoyer.toParticipant!)
            paymentBeforeEnjoyers.append(a)
        }
    }
    func createHistory() {
        
        let moc1 = payment.toParty?.managedObjectContext
        let paymentLogEntity = NSEntityDescription.entity(forEntityName: "PaymentLog", in: stack.context)!
        let payerLogEntity = NSEntityDescription.entity(forEntityName: "PayerLog", in: stack.context)!
        let enjoyerLogEntity = NSEntityDescription.entity(forEntityName: "EnjoyerLog", in: stack.context)!
        
        let paymentBefore = PaymentLog(entity: paymentLogEntity, insertInto: moc1)
        paymentBefore.wName = paymentBeforeName
        paymentBefore.amount = paymentBeforeAmount
        for payer in paymentBeforePayers {
            let payerLog = PayerLog(entity: payerLogEntity, insertInto: moc1)
            payerLog.bandera = payer.bandera
            payerLog.amount = payer.amount
            payerLog.toParticipant = payer.toParticipant
            payerLog.toPaymentLog = paymentBefore
            stack.context.insert(payerLog)
            paymentBefore.payersLogArray.append(payerLog)
        }
        for enjoyer in paymentBeforeEnjoyers {
            let enjoyerLog = EnjoyerLog(entity: enjoyerLogEntity, insertInto: moc1)
            enjoyerLog.bandera = enjoyer.bandera
            enjoyerLog.amount = enjoyer.amount
            enjoyerLog.toParticipant = enjoyer.toParticipant
            enjoyerLog.toPaymentLog = paymentBefore
            stack.context.insert(enjoyerLog)
            paymentBefore.enjoyersLogArray.append(enjoyerLog)
        }
        paymentBefore.toParty = payment.toParty
        stack.context.insert(paymentBefore)
        
        let paymentAfter = PaymentLog(entity: paymentLogEntity, insertInto: moc1)
        paymentAfter.wName = payment.wName
        paymentAfter.amount = payment.amount
        for payer in payment.payersArray {
            let payerLog = PayerLog(entity: payerLogEntity, insertInto: moc1)
            payerLog.bandera = payer.bandera
            payerLog.amount = payer.amount
            payerLog.toParticipant = payer.toParticipant
            payerLog.toPaymentLog = paymentAfter
            stack.context.insert(payerLog)
            paymentAfter.payersLogArray.append(payerLog)
        }
        for enjoyer in payment.enjoyersArray {
            let enjoyerLog = EnjoyerLog(entity: enjoyerLogEntity, insertInto: moc1)
            enjoyerLog.bandera = enjoyer.bandera
            enjoyerLog.amount = enjoyer.amount
            enjoyerLog.toParticipant = enjoyer.toParticipant
            enjoyerLog.toPaymentLog = paymentAfter
            stack.context.insert(enjoyerLog)
            paymentAfter.enjoyersLogArray.append(enjoyerLog)
        }
        paymentAfter.toParty = payment.toParty
        stack.context.insert(paymentAfter)
        
        let paymentChangesEntity = NSEntityDescription.entity(forEntityName: "PaymentChanges", in: stack.context)!
        let paymentChanges = PaymentChanges(entity: paymentChangesEntity, insertInto: moc1)
        
        paymentChanges.when = Date()
        paymentChanges.before = paymentBefore
        paymentChanges.after = paymentAfter
        paymentChanges.toPayment = payment
        paymentChanges.toParty = payment.toParty
        
        stack.context.insert(paymentChanges)
        stack.save()
    }
}

