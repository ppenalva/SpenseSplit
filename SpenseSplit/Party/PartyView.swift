//
//  PartyView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import SwiftUI

struct PartyView: View {
    
    @ObservedObject var party: Party
    
    var theme: Theme = Theme(rawValue: "red") ?? .poppy
    
    private let stack = CoreDataStack.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(party.wName)
                if stack.isShared(object: party) {
                    if stack.isOwner(object: party) {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(theme.accentColor(color: party.wTheme))
                    } else {
                        Image(systemName: "person.fill")
                            .foregroundColor(theme.accentColor(color: party.wTheme))
                    }
                }
                if !canEdit(party) {
                    Image(systemName: "pencil.slash")
                        .foregroundColor(theme.accentColor(color: party.wTheme))
                }
            }
        }
        .padding()
        .foregroundColor(theme.accentColor(color: party.wTheme))
    }
    private func canEdit(_ party: Party) -> Bool {
        stack.canEdit(object: party)
    }
}
