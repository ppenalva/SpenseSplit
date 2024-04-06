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
