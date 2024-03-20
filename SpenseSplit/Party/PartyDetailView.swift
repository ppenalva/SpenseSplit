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
    @State private var isPresentingNewPaymentView = false
    @State private var isPresentingSummaryView = false
    
    @State private var newParticipantName = ""
    
    @State var newExpenseName = ""
    @State var newExpenseAmount = 0.0
    @State var newExpensePayers: [Payer] = []
    @State var newExpenseEnjoyers: [Enjoyer] = []
    
    @State var newPaymentName = ""
    @State var newPaymentAmount = 0.0
    @State var newPaymentPayers: [Payer] = []
    @State var newPaymentEnjoyers: [Enjoyer] = []
    
    //    @State private var viewID: Int = 0
    
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
            Section(header: Text("Party Info")) {
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
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
                Button("Summary") {
                    // logica Resumen
                    isPresentingSummaryView = true
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            Section(header: Text("Participants")) {
                
                ForEach(party.participantsArray) { participant in
                    Text(participant.wName)
                }
                .onDelete (perform: deleteParticipant)
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
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newParticipantName.isEmpty)
                }
            }
            Section(header: Text("Expenses")) {
                ForEach(party.expensesArray) { expense in
                    NavigationLink(destination: ExpenseDetailView(expense: expense)) {
                        HStack {
                            Label(expense.wName, systemImage: "r.circle")
                        }
                    }
                }
                .onDelete(perform: deleteExpenses)
            }
            Section(header: Text("Payements")) {
                ForEach(party.paymentsArray) { payment in
                    NavigationLink(destination: PaymentDetailView(payment: payment)) {
                        HStack {
                            Label(payment.wName, systemImage: "r.circle")
                        }
                    }
                }
                .onDelete(perform: deletePayments)
            }
        }
        .navigationTitle(party.wName)
        .toolbar {
            ToolbarItem {
                HStack {
                    if sharing {
                        ProgressView()
                    }
                    //                 if isOwner {
                    Button {
                        if isShared {
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
                    //                  }
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
                ExpenseNewView(newExpenseName: $newExpenseName, newExpenseAmount: $newExpenseAmount, newExpensePayers: $newExpensePayers, newExpenseEnjoyers: $newExpenseEnjoyers)
                    .navigationTitle("Expenses")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewExpenseView = false
                                newExpenseName = ""
                                newExpenseAmount = 0.0
                                newExpensePayers = []
                                newExpenseEnjoyers = []
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
                                    let moc1 = party.managedObjectContext
                                    let payerEntity = NSEntityDescription.entity(forEntityName: "Payer", in: stack.context)!
                                    let payer = Payer(entity: payerEntity, insertInto: moc1)
                                    payer.toParticipant = newPayer.toParticipant
                                    payer.bandera = newPayer.bandera
                                    stack.context.insert(payer)
                                    expense.payersArray.append(payer)
                                }
                                for newEnjoyer in newExpenseEnjoyers {
                                    let moc1 = party.managedObjectContext
                                    let enjoyerEntity = NSEntityDescription.entity(forEntityName: "Enjoyer", in: stack.context)!
                                    let enjoyer = Enjoyer(entity: enjoyerEntity, insertInto: moc1)
                                    enjoyer.toParticipant = newEnjoyer.toParticipant
                                    enjoyer.bandera = newEnjoyer.bandera
                                    stack.context.insert(enjoyer)
                                    expense.enjoyersArray.append(enjoyer)
                                }
                                stack.context.insert(expense)
                                stack.save()
                                isPresentingNewExpenseView = false
                                newExpenseName = ""
                                newExpenseAmount = 0.0
                                newExpensePayers = []
                                newExpenseEnjoyers = []
                            }
                        }
                    }
            }
        }
        .sheet(isPresented: $isPresentingNewPaymentView) {
            NavigationView {
                PaymentNewView(newPaymentName: $newPaymentName, newPaymentAmount: $newPaymentAmount, newPaymentPayers: $newPaymentPayers, newPaymentEnjoyers: $newPaymentEnjoyers)
                    .navigationTitle("Payments")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewPaymentView = false
                                newPaymentName = ""
                                newPaymentAmount = 0.0
                                newPaymentPayers = []
                                newPaymentEnjoyers = []
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
                                    let moc1 = party.managedObjectContext
                                    let payerEntity = NSEntityDescription.entity(forEntityName: "Payer", in: stack.context)!
                                    let payer = Payer(entity: payerEntity, insertInto: moc1)
                                    payer.toParticipant = newPayer.toParticipant
                                    payer.bandera = newPayer.bandera
                                    stack.context.insert(payer)
                                    payment.payersArray.append(payer)
                                }
                                for newEnjoyer in newPaymentEnjoyers {
                                    let moc1 = party.managedObjectContext
                                    let enjoyerEntity = NSEntityDescription.entity(forEntityName: "Enjoyer", in: stack.context)!
                                    let enjoyer = Enjoyer(entity: enjoyerEntity, insertInto: moc1)
                                    enjoyer.toParticipant = newEnjoyer.toParticipant
                                    enjoyer.bandera = newEnjoyer.bandera
                                    stack.context.insert(enjoyer)
                                    payment.enjoyersArray.append(enjoyer)
                                }
                                stack.context.insert(payment)
                                stack.save()
                                isPresentingNewPaymentView = false
                                newPaymentName = ""
                                newPaymentAmount = 0.0
                                newPaymentPayers = []
                                newPaymentEnjoyers = []
                            }
                        }
                    }
            }
        }
    }
    private func openSharingController(party: Party, participant: Participant, expense: Expense, payment: Payment) {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first
        
        //       let cloudSharingController = UICloudSharingController { (share: CKshare, container: CKcontainer)
        
        
        let sharingController = UICloudSharingController {
            (_, completion: @escaping (CKShare?, CKContainer?, Error?) -> Void) in
            stack.persistentContainer.share([party], to: nil) { _, share, container, error in
                if let actualShare = share {
                    party.managedObjectContext?.performAndWait {
                        actualShare[CKShare.SystemFieldKey.title] = party.name
                    }
                }
                completion(share, container, error)
            }
            stack.persistentContainer.share([participant], to: nil) { _, share, container, error in
                if let actualShare = share {
                    participant.managedObjectContext?.performAndWait {
                        actualShare[CKShare.SystemFieldKey.title] = participant.name
                    }
                }
                completion(share, container, error)
            }
            stack.persistentContainer.share([expense], to: nil) { _, share, container, error in
                if let actualShare = share {
                    expense.managedObjectContext?.performAndWait {
                        actualShare[CKShare.SystemFieldKey.title] = expense.name
                    }
                }
                completion(share, container, error)
            }
            stack.persistentContainer.share([payment], to: nil) { _, share, container, error in
                if let actualShare = share {
                    payment.managedObjectContext?.performAndWait {
                        actualShare[CKShare.SystemFieldKey.title] = payment.name
                    }
                }
                completion(share, container, error)
            }
        }
        keyWindow?.rootViewController?.present(sharingController, animated: true)
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
}

