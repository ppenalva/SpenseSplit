//
//  SendersDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 13/2/24.
//

import SwiftUI

struct SendersDetailView: View {
    
    @ObservedObject var payment: Payment
    
    var body: some View {
        List {
            ForEach($payment.payersArray) { $payer in
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
