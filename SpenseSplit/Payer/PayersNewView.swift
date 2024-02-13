//
//  PayersNewView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 12/2/24.
//

import SwiftUI

struct PayersNewView: View {
    
    @Binding var newExpensePayers: [Payer]
    
    var body: some View {
        List {
            ForEach($newExpensePayers) { $payer in
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
