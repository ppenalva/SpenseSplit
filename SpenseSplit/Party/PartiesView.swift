//
//  PartiesView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import SwiftUI
import CoreData

struct PartiesView: View {

    @FetchRequest(entity: Party.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Party.name, ascending: false)]) var parties: FetchedResults<Party>
    
    private let stack = CoreDataStack.shared
    
    @State private var isPresentingNewPartyView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(parties) { party in
                    NavigationLink (destination: PartyDetailView( party: party))
                    {PartyView( party: party)}
                        .listRowBackground(Color(party.wTheme))
                }
                .onDelete(perform: deleteParties)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        withAnimation {
                            isPresentingNewPartyView = true
                        }
                    }
                label: {
                    Image(systemName: "plus")
                }
                }
            }
            .navigationTitle("PARTIES")
            .sheet(isPresented: $isPresentingNewPartyView) {
                NavigationView {
                    
                    let partyEntity = NSEntityDescription.entity(forEntityName: "Party", in: stack.context)!
                    let party = Party (entity: partyEntity, insertInto: nil)
                    
                    PartyNewView(party: party)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingNewPartyView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    if party.wTheme == "" {
                                        party.wTheme = "bubblegum"
                                    }
                                    stack.context.insert(party)
                                    stack.save()
                                    isPresentingNewPartyView = false
                                }
                            }
                        }
                }
            }
        }
    }
    private func deleteParties(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                stack.context.delete(parties[index])
            }
            stack.save()
        }
    }
}
