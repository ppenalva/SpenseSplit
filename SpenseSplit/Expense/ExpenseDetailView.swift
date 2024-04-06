//
//  ExpenseDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 11/2/24.
//

import SwiftUI
import CoreData

struct ExpenseDetailView: View {
    
    @Binding var expense: Expense
    @Binding var theId: Int
    @Binding var validExpense: Bool
    @Binding var validPayment: Bool
    @Binding var firstCallExpense: Bool
    
    private let stack = CoreDataStack.shared
    
    @State private var isPresentingDetailPayersView = false
    @State private var isPresentingDetailEnjoyersView = false
    
    struct PayerEnjoyer {
        var bandera: Bool
        var amount: Double
        var toParticipant: Participant
    }
    
    @State private var expenseBeforeName = ""
    @State private var expenseBeforeAmount = 0.0
    @State private var expenseBeforePayers: [PayerEnjoyer] = []
    @State private var expenseBeforeEnjoyers: [PayerEnjoyer] = []
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var btnBack : some View { Button(action: {
        theId += 1
        createHistory()
        self.presentationMode.wrappedValue.dismiss()
    }) {
        Text(expense.toParty!.wName)
    }
    .disabled(!validExpense)
    }
    
    @State var validPayer = false
    @State var validEnjoyer = false
    
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
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .sheet(isPresented: $isPresentingDetailPayersView) {
            NavigationView {
                PayersDetailView(expense: expense, validPayer: $validPayer, validEnjoyer: $validEnjoyer, validExpense: $validExpense, validPayment: $validPayment, theId: $theId)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingDetailPayersView = false
                                stack.context.rollback()
                                theId += 1
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                isPresentingDetailPayersView = false
                                stack.save()
                            }
                            .disabled(!validPayer)
                        }
                    }
            }
        }
        .sheet(isPresented: $isPresentingDetailEnjoyersView) {
            NavigationView {
                EnjoyersDetailView(expense: expense, validPayer: $validPayer, validEnjoyer: $validEnjoyer, validExpense: $validExpense, validPayment: $validPayment, theId: $theId)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingDetailEnjoyersView = false
                                stack.context.rollback()
                                theId += 1
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                isPresentingDetailEnjoyersView = false
                                stack.save()
                            }
                            .disabled(!validEnjoyer)
                        }
                    }
            }
        }
        .onAppear(perform: keepInitial)
        .id(theId)
    }
    func keepInitial() {
        if firstCallExpense {
            expenseBeforeName = expense.wName
            expenseBeforeAmount = expense.amount
            for payer in expense.payersArray {
                let a = PayerEnjoyer(bandera: payer.bandera, amount: payer.amount, toParticipant: payer.toParticipant!)
                expenseBeforePayers.append(a)
            }
            for enjoyer in expense.enjoyersArray {
                let a = PayerEnjoyer(bandera: enjoyer.bandera, amount: enjoyer.amount, toParticipant: enjoyer.toParticipant!)
                expenseBeforeEnjoyers.append(a)
            }
            firstCallExpense = false
        }
    }
    func createHistory() {
        
        let moc1 = expense.toParty?.managedObjectContext
        let expenseLogEntity = NSEntityDescription.entity(forEntityName: "ExpenseLog", in: stack.context)!
        let payerLogEntity = NSEntityDescription.entity(forEntityName: "PayerLog", in: stack.context)!
        let enjoyerLogEntity = NSEntityDescription.entity(forEntityName: "EnjoyerLog", in: stack.context)!
        
        let expenseBefore = ExpenseLog(entity: expenseLogEntity, insertInto: moc1)
        expenseBefore.wName = expenseBeforeName
        expenseBefore.amount = expenseBeforeAmount
        for payer in expenseBeforePayers {
            let payerLog = PayerLog(entity: payerLogEntity, insertInto: moc1)
            payerLog.bandera = payer.bandera
            payerLog.amount = payer.amount
            payerLog.toParticipant = payer.toParticipant
            payerLog.toExpenseLog = expenseBefore
            stack.context.insert(payerLog)
            expenseBefore.payersLogArray.append(payerLog)
        }
        for enjoyer in expenseBeforeEnjoyers {
            let enjoyerLog = EnjoyerLog(entity: enjoyerLogEntity, insertInto: moc1)
            enjoyerLog.bandera = enjoyer.bandera
            enjoyerLog.amount = enjoyer.amount
            enjoyerLog.toParticipant = enjoyer.toParticipant
            enjoyerLog.toExpenseLog = expenseBefore
            stack.context.insert(enjoyerLog)
            expenseBefore.enjoyersLogArray.append(enjoyerLog)
        }
        expenseBefore.toParty = expense.toParty
        stack.context.insert(expenseBefore)
        
        let expenseAfter = ExpenseLog(entity: expenseLogEntity, insertInto: moc1)
        expenseAfter.wName = expense.wName
        expenseAfter.amount = expense.amount
        for payer in expense.payersArray {
            let payerLog = PayerLog(entity: payerLogEntity, insertInto: moc1)
            payerLog.bandera = payer.bandera
            payerLog.amount = payer.amount
            payerLog.toParticipant = payer.toParticipant
            payerLog.toExpenseLog = expenseAfter
            stack.context.insert(payerLog)
            expenseAfter.payersLogArray.append(payerLog)
        }
        for enjoyer in expense.enjoyersArray {
            let enjoyerLog = EnjoyerLog(entity: enjoyerLogEntity, insertInto: moc1)
            enjoyerLog.bandera = enjoyer.bandera
            enjoyerLog.amount = enjoyer.amount
            enjoyerLog.toParticipant = enjoyer.toParticipant
            enjoyerLog.toExpenseLog = expenseAfter
            stack.context.insert(enjoyerLog)
            expenseAfter.enjoyersLogArray.append(enjoyerLog)
        }
        expenseAfter.toParty = expense.toParty
        stack.context.insert(expenseAfter)
        
        let expenseChangesEntity = NSEntityDescription.entity(forEntityName: "ExpenseChanges", in: stack.context)!
        let expenseChanges = ExpenseChanges(entity: expenseChangesEntity, insertInto: moc1)
        
        expenseChanges.when = Date()
        expenseChanges.before = expenseBefore
        expenseChanges.after = expenseAfter
        expenseChanges.toExpense = expense
        expenseChanges.toParty = expense.toParty
        
        stack.context.insert(expenseChanges)
        stack.save()
    }
}

