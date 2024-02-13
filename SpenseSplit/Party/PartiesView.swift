//
//  PartiesView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import SwiftUI
import CoreData

struct PartiesView: View {
    
    private let stack = CoreDataStack.shared
    
    @FetchRequest(entity: Party.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Party.name, ascending: false)]) var parties: FetchedResults<Party>
    
    @State private var isPresentingNewPartyView = false
    
    @State var newPartyName = ""
    @State var newPartyTheme = ""
    @State var newPartyParticipants: [Participant] = []
    
    var theme: Theme = Theme(rawValue: "poppy") ?? .orange
    
    var body: some View {
        
        NavigationSplitView {
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
                    PartyNewView(newPartyName: $newPartyName, newPartyTheme: $newPartyTheme, newPartyParticipants: $newPartyParticipants)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Dismiss") {
                                    isPresentingNewPartyView = false
                                    newPartyName = ""
                                    newPartyTheme = ""
                                    newPartyParticipants = []
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    let partyEntity = NSEntityDescription.entity(forEntityName: "Party", in: stack.context)!
                                    let party = Party(entity: partyEntity, insertInto: nil)
                                    party.name = newPartyName
                                    party.theme = newPartyTheme
                                    for newParticipant in newPartyParticipants {
                                        let moc1 = party.managedObjectContext
                                        let participantEntity = NSEntityDescription.entity(forEntityName: "Participant", in: stack.context)!
                                        let participant = Participant(entity: participantEntity, insertInto: moc1)
                                        participant.wName = newParticipant.wName
                                        stack.context.insert(participant)
                                        party.participantsArray.append(participant)
                                    }
                                    stack.context.insert(party)
                                    stack.save()
                                    isPresentingNewPartyView = false
                                    newPartyName = ""
                                    newPartyTheme = ""
                                    newPartyParticipants = []
                                }
                            }
                        }
                }
            }
        } detail: {
            Text("Select an item")
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
