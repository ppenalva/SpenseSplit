//
//  PartyDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import CloudKit
import CoreData
import SwiftUI

struct PartyDetailView: View {
    
    @ObservedObject var party: Party
    private let stack = CoreDataStack.shared
    
    @FetchRequest(entity: Participant.entity(), sortDescriptors: []) var participants: FetchedResults<Participant>
    @FetchRequest(entity: Expense.entity(), sortDescriptors: []) var expenses: FetchedResults<Expense>
    @FetchRequest(entity: Payment.entity(), sortDescriptors: []) var payments: FetchedResults<Payment>
    
    @State var sharing = false
    
    @State private var showShareController = false
    
    @State private var isPresentingNewExpenseView = false
    @State private var isPresentingDetailExpenseView = false
    @State private var isPresentingNewPaymentView = false
    @State private var isPresentingDetailPaymentView = false
    @State private var isPresentingSummaryView = false
    @State private var isPresentingHistoryView = false
    
    @State private var newParticipantName = ""
    
    @State var newExpenseName = ""
    @State var newExpenseAmount = 0.0
    @State var newExpensePayers: [Payer] = []
    @State var newExpenseEnjoyers: [Enjoyer] = []
    
    @State var newPaymentName = ""
    @State var newPaymentAmount = 0.0
    @State var newPaymentPayers: [Payer] = []
    @State var newPaymentEnjoyers: [Enjoyer] = []
    
    @State private var expenseSelected: Expense = Expense()
    @State private var paymentSelected: Payment = Payment()
    
    struct work01 {
        var participant: Participant
        var amount: Double
    }
    @State private var work01s: [work01] = []
    @State private var work02s: [work01] = []
    
    @State var theId = 0
    
    @State var validExpense = false
    @State var validPayment = true
    
    @State var firstCallExpense = false
    @State var firstCallPayment = false
    
    init(party: Party) {
        self.party = party
        _participants = FetchRequest(entity: Participant.entity(),
                                     sortDescriptors: [],
                                     predicate: NSPredicate(format: "%K = %@", #keyPath(Participant.toParty), party),
                                     animation: .default)
        _expenses = FetchRequest(entity: Expense.entity(),
                                 sortDescriptors: [],
                                 predicate: NSPredicate(format: "%K = %@", #keyPath(Expense.toParty),party),
                                 animation: .default)
        _payments = FetchRequest(entity: Payment.entity(),
                                 sortDescriptors: [],
                                 predicate: NSPredicate(format: "%K = %@", #keyPath(Payment.toParty),party),
                                 animation: .default)
    }
    
    var body: some View {
        List {
            Section(header: Text("Party Info" )) {
                TextField("Name", text: $party.wName)
                ThemePicker(selection: $party.wTheme)
            }
            HStack {
                Button("New Expense") {
                    for newPayer  in party.participantsArray {
                        let moc1 = party.managedObjectContext
                        let payerEntity = NSEntityDescription.entity(forEntityName: "Payer", in: stack.context)!
                        let payer = Payer(entity: payerEntity, insertInto: moc1)
                        payer.toParticipant = newPayer
                        payer.bandera = false
                        newExpensePayers.append(payer)
                    }
                    for newEnjoyer  in party.participantsArray {
                        let moc1 = party.managedObjectContext
                        let enjoyerEntity = NSEntityDescription.entity(forEntityName: "Enjoyer", in: stack.context)!
                        let enjoyer = Enjoyer(entity: enjoyerEntity, insertInto: moc1)
                        enjoyer.toParticipant = newEnjoyer
                        enjoyer.bandera = false
                        newExpenseEnjoyers.append(enjoyer)
                    }
                    isPresentingNewExpenseView = true
                    validExpense = false
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
                Button("New Payment") {
                    for newPayer  in party.participantsArray {
                        let moc1 = party.managedObjectContext
                        let payerEntity = NSEntityDescription.entity(forEntityName: "Payer", in: stack.context)!
                        let payer = Payer(entity: payerEntity, insertInto: moc1)
                        payer.toParticipant = newPayer
                        payer.bandera = false
                        newPaymentPayers.append(payer)
                    }
                    for newEnjoyer  in party.participantsArray {
                        let moc1 = party.managedObjectContext
                        let enjoyerEntity = NSEntityDescription.entity(forEntityName: "Enjoyer", in: stack.context)!
                        let enjoyer = Enjoyer(entity: enjoyerEntity, insertInto: moc1)
                        enjoyer.toParticipant = newEnjoyer
                        enjoyer.bandera = false
                        newPaymentEnjoyers.append(enjoyer)
                    }
                    isPresentingNewPaymentView = true
                    validPayment = false
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            Section(header: Text("Participants")) {
                ForEach(party.participantsArray) { participant in
                    let c = calculateTotal(participant: participant)
                    HStack {
                        Text(participant.wName)
                        Spacer()
                        Text(String(format: "%.2f",c))
                    }
                    .swipeActions {
                        Button(role: .none) {
                            //             Calculo de importes a cobrar
                            //         crear matriz con los importes a cobrar
                            work01s = []
                            for participant in (party.participantsArray) {
                            work01s.append(work01(participant: participant, amount: calculateTotal(participant: participant)))
                            }
                            // ordenar la matriz
                            work01s.sort { (lhs: work01, rhs: work01) in
                            return lhs.amount > rhs.amount
                            }
                            // crear matriz con los cobros propuestos
                            work02s = []
                            var work03 = c * -1
                            for entry in work01s {
                            if work03 > 0.01 {
                            if (entry.amount >= work03) {
                            work02s.append(work01(participant: entry.participant, amount: work03))
                                break
                            } else {
                            work02s.append(work01(participant: entry.participant, amount: entry.amount))
                            work03 -= entry.amount
                            }
                        }
                    }
                    // crear el pago automatico
                    newPaymentName = "Closing of   \(participant.wName)"
                    newPaymentAmount = c * -1
                            for newPayer in party.participantsArray {
                                let moc1 = party.managedObjectContext
                                let payerEntity = NSEntityDescription.entity(forEntityName: "Payer", in: stack.context)!
                                let payer = Payer(entity: payerEntity, insertInto: moc1)
                                payer.toParticipant = newPayer
                                if (newPayer == participant)
                                {
                                    payer.bandera = true
                                    payer.amount = c * -1
                                    newPaymentPayers.append(payer)
                                } else {
                                    payer.bandera = false
                                    payer.amount = 0.0
                                    newPaymentPayers.append(payer)
                                }
                            }
                            for newEnjoyer in party.participantsArray {
                                var found = false
                                let moc1 = party.managedObjectContext
                                let enjoyerEntity = NSEntityDescription.entity(forEntityName: "Enjoyer", in: stack.context)!
                                let enjoyer = Enjoyer(entity: enjoyerEntity, insertInto: moc1)
                                enjoyer.toParticipant = newEnjoyer
                                for entry in work02s {
                                    if (newEnjoyer == entry.participant)
                                    {
                                        enjoyer.bandera = true
                                        enjoyer.amount = entry.amount
                                        newPaymentEnjoyers.append(enjoyer)
                                        found = true
                                    }
                                }
                                if (found == false) {
                                    enjoyer.bandera = false
                                    enjoyer.amount = 0.0
                                    newPaymentEnjoyers.append(enjoyer)
                                }
                            }
                            validPayment = true
                            isPresentingNewPaymentView = true
                        }
                    label: {
                        Label("Liq", systemImage: "banknote")
                    }
                    .tint(.orange)
                        Button(role: .destructive ) {
                            withAnimation {
                                stack.context.delete(participant)
                                stack.save()
                            }
                        }
                    label: {
                        Label("Del", systemImage: "trash")
                    }
                    .tint(.red)
                    }
                }
                HStack {
                    TextField("New Participant", text: $newParticipantName)
                    Button(action: {
                        withAnimation {
                            let moc1 = party.managedObjectContext
                            let participantEntity = NSEntityDescription.entity(forEntityName: "Participant", in: stack.context)!
                            let participant = Participant(entity: participantEntity, insertInto: moc1)
                            participant.toParty = party
                            participant.name = newParticipantName
                            stack.context.insert(participant)
                            newParticipantName = ""
                            stack.save()
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newParticipantName.isEmpty)
                }
            }
        HStack {
            Button("Summary") {
                isPresentingSummaryView = true
            }
            .buttonStyle(BorderlessButtonStyle())
            Spacer()
            Button("History") {
                isPresentingHistoryView = true
            }
            .buttonStyle(BorderlessButtonStyle())
        }
            Section(header: Text("Expenses")) {
                ForEach(party.expensesArray) { expense in
                    NavigationLink(destination: ExpenseDisplayView(expense: expense)) {
                        HStack {
                            Label(expense.wName, systemImage: "r.circle")
                        }
                        .swipeActions {
                            Button(role: .none) {
                                    expenseSelected = expense
                                firstCallExpense = true
                                    isPresentingDetailExpenseView = true
                                validExpense = false
                            }
                        label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                            Button(role: .destructive ) {
                                withAnimation {
                                    
                                    let moc1 = party.managedObjectContext
                                    let expenseLogEntity = NSEntityDescription.entity(forEntityName: "ExpenseLog", in: stack.context)!
                                    let payerLogEntity = NSEntityDescription.entity(forEntityName: "PayerLog", in: stack.context)!
                                    let enjoyerLogEntity = NSEntityDescription.entity(forEntityName: "EnjoyerLog", in: stack.context)!
                                    
                                    let expenseBefore = ExpenseLog(entity: expenseLogEntity, insertInto: moc1)
                                    expenseBefore.wName = expense.wName
                                    expenseBefore.amount = expense.amount
                                    for payer in expense.payersArray {
                                        let payerLog = PayerLog(entity: payerLogEntity, insertInto: moc1)
                                        payerLog.bandera = payer.bandera
                                        payerLog.amount = payer.amount
                                        payerLog.toParticipant = payer.toParticipant
                                        payerLog.toExpenseLog = expenseBefore
                                        stack.context.insert(payerLog)
                                        expenseBefore.payersLogArray.append(payerLog)
                                    }
                                    for enjoyer in expense.enjoyersArray {
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
                                    expenseAfter.wName = "Delete"
                                    expenseAfter.amount = 0.0
                                    expenseAfter.toParty = party
                                    stack.context.insert(expenseAfter)
                                    
                                    let expenseChangesEntity = NSEntityDescription.entity(forEntityName: "ExpenseChanges", in: stack.context)!
                                    let expenseChanges = ExpenseChanges(entity: expenseChangesEntity, insertInto: moc1)
                                    
                                    expenseChanges.when = Date()
                                    expenseChanges.before = expenseBefore
                                    expenseChanges.after = expenseAfter
                                    expenseChanges.toExpense = expense
                                    expenseChanges.toParty = expense.toParty
                                    stack.context.insert(expenseChanges)
                                    
                                    stack.context.delete(expense)
                                    stack.save()
                                }
                            }
                        label: {
                            Label("Del", systemImage: "trash")
                        }
                        .tint(.red)
                        }
                    }
                }
            }
            Section(header: Text("Payements")) {
                ForEach(party.paymentsArray) { payment in
                    NavigationLink(destination: PaymentDisplayView(payment: payment)) {
                        HStack {
                            Label(payment.wName, systemImage: "r.circle")
                        }
                        .swipeActions {
                            Button(role: .none) {
                                    paymentSelected = payment
                                firstCallPayment = true
                                    isPresentingDetailPaymentView = true
                                validPayment = false
                            }
                        label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.blue)
                            Button(role: .destructive ) {
                                withAnimation {
                                    
                                    let moc1 = party.managedObjectContext
                                    let paymentLogEntity = NSEntityDescription.entity(forEntityName: "PaymentLog", in: stack.context)!
                                    let payerLogEntity = NSEntityDescription.entity(forEntityName: "PayerLog", in: stack.context)!
                                    let enjoyerLogEntity = NSEntityDescription.entity(forEntityName: "EnjoyerLog", in: stack.context)!
                                    
                                    let paymentBefore = PaymentLog(entity: paymentLogEntity, insertInto: moc1)
                                    paymentBefore.wName = payment.wName
                                    paymentBefore.amount = payment.amount
                                    for payer in payment.payersArray {
                                        let payerLog = PayerLog(entity: payerLogEntity, insertInto: moc1)
                                        payerLog.bandera = payer.bandera
                                        payerLog.amount = payer.amount
                                        payerLog.toParticipant = payer.toParticipant
                                        payerLog.toPaymentLog = paymentBefore
                                        stack.context.insert(payerLog)
                                        paymentBefore.payersLogArray.append(payerLog)
                                    }
                                    for enjoyer in payment.enjoyersArray {
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
                                    paymentAfter.wName = "Delete"
                                    paymentAfter.amount = 0.0
                                    paymentAfter.toParty = party
                                    stack.context.insert(paymentAfter)
                                    
                                    let paymentChangesEntity = NSEntityDescription.entity(forEntityName: "PaymentChanges", in: stack.context)!
                                    let paymentChanges = PaymentChanges(entity: paymentChangesEntity, insertInto: moc1)
                                    
                                    paymentChanges.when = Date()
                                    paymentChanges.before = paymentBefore
                                    paymentChanges.after = paymentAfter
                                    paymentChanges.toPayment = payment
                                    paymentChanges.toParty = payment.toParty
                                    stack.context.insert(paymentChanges)
                                   
                                    stack.context.delete(payment)
                                    stack.save()
                                }
                            }
                        label: {
                            Label("Del", systemImage: "trash")
                        }
                        .tint(.red)
                        }
                    }
                }
            }
        }
        .id(theId)
        .navigationTitle(party.wName)
        .toolbar {
            ToolbarItem {
                HStack {
                    if sharing {
                        ProgressView()
                    }
                    if ( !isShared || isOwner) {
                        Button {
                            if (isShared) {
                                showShareController = true
                            } else {
                                Task.detached {
                                    await createShare(party)
                                }
                            }
                        }
                    label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    }
                }
                .controlGroupStyle(.navigation)
            }
        }
        .navigationTitle(party.wName)
        .sheet(isPresented: $showShareController) {
            let share = stack.getShare(party)!
            CloudSharingView(share: share, container: stack.ckContainer, party: party)
                .ignoresSafeArea()
        }
        .onDisappear(perform: {
            stack.save()})
        .sheet(isPresented: $isPresentingNewExpenseView) {
            NavigationView {
                ExpenseNewView(newExpenseName: $newExpenseName, newExpenseAmount: $newExpenseAmount, newExpensePayers: $newExpensePayers, newExpenseEnjoyers: $newExpenseEnjoyers, validExpense: $validExpense, validPayment: $validPayment)
                    .navigationTitle("Expenses")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewExpenseView = false
                                newExpenseName = ""
                                newExpenseAmount = 0.0
                                newExpensePayers = []
                                newExpenseEnjoyers = []
                                stack.context.rollback()
                                theId += 1
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let moc1 = party.managedObjectContext
                                let expenseEntity = NSEntityDescription.entity(forEntityName: "Expense", in: stack.context)!
                                let expense = Expense(entity: expenseEntity, insertInto: moc1)
                                expense.name = newExpenseName
                                expense.amount = newExpenseAmount
                                expense.toParty = party
                                for newPayer  in newExpensePayers {
                                    expense.payersArray.append(newPayer)
                                }
                                for newEnjoyer in newExpenseEnjoyers {
                                    expense.enjoyersArray.append(newEnjoyer)
                                }
                                stack.context.insert(expense)
                                
                                let expenseLogEntity = NSEntityDescription.entity(forEntityName: "ExpenseLog", in: stack.context)!
                                let payerLogEntity = NSEntityDescription.entity(forEntityName: "PayerLog", in: stack.context)!
                                let enjoyerLogEntity = NSEntityDescription.entity(forEntityName: "EnjoyerLog", in: stack.context)!
                                
                                let expenseBefore = ExpenseLog(entity: expenseLogEntity, insertInto: moc1)
                                expenseBefore.wName = "Creation"
                                expenseBefore.amount = 0.0
                                expenseBefore.toParty = party
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
                                isPresentingNewExpenseView = false
                                newExpenseName = ""
                                newExpenseAmount = 0.0
                                newExpensePayers = []
                                newExpenseEnjoyers = []
                            }
                            .disabled(!validExpense)
                        }
                    }
            }
        }
        .sheet(isPresented: $isPresentingNewPaymentView) {
            NavigationView {
                PaymentNewView(newPaymentName: $newPaymentName, newPaymentAmount: $newPaymentAmount, newPaymentPayers: $newPaymentPayers, newPaymentEnjoyers: $newPaymentEnjoyers, validExpense: $validExpense, validPayment: $validPayment)
                    .navigationTitle("Payments")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewPaymentView = false
                                newPaymentName = ""
                                newPaymentAmount = 0.0
                                newPaymentPayers = []
                                newPaymentEnjoyers = []
                                stack.context.rollback()
                                theId += 1
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let moc1 = party.managedObjectContext
                                let paymentEntity = NSEntityDescription.entity(forEntityName: "Payment", in: stack.context)!
                                let payment = Payment(entity: paymentEntity, insertInto: moc1)
                                payment.name = newPaymentName
                                payment.amount = newPaymentAmount
                                payment.toParty = party
                                for newPayer  in newPaymentPayers {
                                    payment.payersArray.append(newPayer)
                                }
                                for newEnjoyer in newPaymentEnjoyers {
                                    payment.enjoyersArray.append(newEnjoyer)
                                }
                                stack.context.insert(payment)
                                
                                let paymentLogEntity = NSEntityDescription.entity(forEntityName: "PaymentLog", in: stack.context)!
                                let payerLogEntity = NSEntityDescription.entity(forEntityName: "PayerLog", in: stack.context)!
                                let enjoyerLogEntity = NSEntityDescription.entity(forEntityName: "EnjoyerLog", in: stack.context)!
                                
                                let paymentBefore = PaymentLog(entity: paymentLogEntity, insertInto: moc1)
                                paymentBefore.wName = "Creation"
                                paymentBefore.amount = 0.0
                                paymentBefore.toParty = party
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
                                isPresentingNewPaymentView = false
                                newPaymentName = ""
                                newPaymentAmount = 0.0
                                newPaymentPayers = []
                                newPaymentEnjoyers = []
                            }
                            .disabled(!validPayment)
                        }
                    }
            }
        }
        .sheet(isPresented: $isPresentingSummaryView) {
            NavigationView {
                SummaryView(party: party)
                    .navigationTitle("Summary")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Back") {
                                isPresentingSummaryView = false
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $isPresentingHistoryView) {
            NavigationView {
                HistoryView(party: party)
                    .navigationTitle("History")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Back") {
                                isPresentingHistoryView = false
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $isPresentingDetailExpenseView) {
            NavigationView {
                ExpenseDetailView(expense: $expenseSelected, theId: $theId, validExpense: $validExpense, validPayment: $validPayment, firstCallExpense: $firstCallExpense)
            }
        }
        .sheet(isPresented: $isPresentingDetailPaymentView) {
            NavigationView {
                PaymentDetailView(payment: $paymentSelected, theId: $theId, validExpense: $validExpense, validPayment: $validPayment, firstCallPayment: $firstCallPayment)
            }
        }
    }
    private var isShared: Bool {
        stack.isShared(object: party)
    }
    private var isOwner: Bool {
        stack.isOwner(object: party)
    }
    private var canEdit: Bool {
        stack.canEdit(object: party)
    }
    func createShare(_ party: Party) async {
        sharing = true
        do {
            let (_, share, _) = try await stack.persistentContainer.share([party], to: nil)
            share[CKShare.SystemFieldKey.title] = party.name
        } catch {
            print("Fail to create share")
            sharing = false
        }
        sharing = false
        showShareController = true
    }
    func deleteExpenses( at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                stack.context.delete(expenses[index])
            }
        }
    }
    func deletePayments( at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                stack.context.delete(payments[index])
            }
        }
    }
    func deleteParticipant( at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                stack.context.delete(participants[index])
            }
        }
    }
    func calculateTotal(participant: Participant) ->  Double {
        var total = 0.0
        for payment in participant.payersArray  {
            total = total + payment.amount
        }
        for payment in participant.enjoyersArray {
            total = total - payment.amount
        }
        return total
    }
}

