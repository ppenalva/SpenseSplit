//
//  SenderNewView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 12/2/24.
//

import SwiftUI

struct SendersNewView: View {
    
    @Binding var newPaymentPayers: [Payer]
    
    var body: some View {
        List {
            ForEach($newPaymentPayers) { $payer in
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
