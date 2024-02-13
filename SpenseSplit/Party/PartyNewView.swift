//
//  PartyNewView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import CloudKit
import CoreData
// import Foundation
import SwiftUI
// import UIKit

struct PartyNewView: View {
    
    @Binding var newPartyName: String
    @Binding var newPartyTheme: String
    @Binding var newPartyParticipants: [Participant]
    
    private let stack = CoreDataStack.shared
    
    @State private var newParticipantName = ""
    
    var body: some View {
        List {
            Section(header: Text("Party Info")) {
                TextField("Name", text: $newPartyName)
               ThemePicker(selection: $newPartyTheme)
            }
            Section(header: Text("Participants")) {
                ForEach( newPartyParticipants ) { participant in
                    HStack {
                        Text(participant.wName)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            stack.context.delete(participant)
                        }
                    label: {
                        Label("Del", systemImage: "trash")
                    }
                    }
                }
                HStack {
                    TextField("New Participant", text: $newParticipantName)
                    Button(action: {
                        withAnimation {
                            let participantEntity = NSEntityDescription.entity(forEntityName: "Participant", in: stack.context)!
                            let newPartyParticipant = Participant(entity: participantEntity, insertInto: nil)
                            newPartyParticipant.wName = newParticipantName
                            newPartyParticipants.append(newPartyParticipant)
                            newParticipantName = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newParticipantName.isEmpty)
                }
            }
        }
    }
}
