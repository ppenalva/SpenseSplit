//
//  PayersDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 12/2/24.
//

import SwiftUI

struct PayersDetailView: View {
    
    @ObservedObject var expense: Expense
    
    var body: some View {
        List {
            ForEach($expense.payersArray) { $payer in
                HStack {
                    Toggle(isOn: $payer.bandera){}
                    Spacer()
                    Text(payer.toParticipant!.wName)
                    Spacer()
                    TextField("Amount", value: $payer.amount, format: .number)
                }
            }
        }
    }
}
