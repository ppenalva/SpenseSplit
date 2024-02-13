//
//  ReceiverNewView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 12/2/24.
//

import SwiftUI

struct ReceiversNewView: View {
    
    @Binding var newPaymentEnjoyers: [Enjoyer]
    
    var body: some View {
        List {
            ForEach($newPaymentEnjoyers) { $enjoyer in
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
