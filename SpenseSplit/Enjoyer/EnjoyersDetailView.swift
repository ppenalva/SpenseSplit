//
//  EnjoyersDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 12/2/24.
//

import SwiftUI

struct EnjoyersDetailView: View {
    
    @ObservedObject var expense: Expense
    
    var body: some View {
        List {
            ForEach($expense.enjoyersArray) { $enjoyer in
                HStack {
                    Toggle(isOn: $enjoyer.bandera){}
                    Spacer()
                    Text(enjoyer.toParticipant!.wName)
                    Spacer()
                    TextField("Amount", value: $enjoyer.amount, format: .number)
                }
            }
        }
    }
}
