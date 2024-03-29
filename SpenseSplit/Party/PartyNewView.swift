//
//  PartyNewView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import CoreData
import SwiftUI


struct PartyNewView: View {
    
    @ObservedObject var party: Party
    
    private let stack = CoreDataStack.shared
    
    @State private var newParticipantName = ""
    
    var body: some View {
        List {
            Section(header: Text("Party Info")) {
                TextField("Name", text: $party.wName)
                ThemePicker(selection: $party.wTheme)
            }
//            Section(header: Text("Participants")) {
//                ForEach( party.participantsArray ) { participant in
//                    HStack {
//                        Text(participant.wName)
//                    }
//                }
//                .onDelete (perform: deleteParticipant)
//                HStack {
//                    TextField("New Participant", text: $newParticipantName)
//                    Button(action: {
//                        withAnimation {
//                            let moc1 = party.managedObjectContext
//                            let participantEntity = NSEntityDescription.entity(forEntityName: "Participant", in: stack.context)!
//                            let newParticipant = Participant(entity: participantEntity, insertInto: moc1)
//                            newParticipant.wName = newParticipantName
//                            newParticipant.toParty = party
//                            party.participantsArray.append(newParticipant)
//                            stack.context.insert(newParticipant)
//                            newParticipantName = ""
//                        }
//                    }) {
//                        Image(systemName: "plus.circle.fill")
//                    }
//                    .disabled(newParticipantName.isEmpty)
//                }
//            }
        }
    }
    func deleteParticipant( at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                stack.context.delete(party.participantsArray[index])
            }
        }
    }
}
