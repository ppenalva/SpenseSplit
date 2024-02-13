//
//  ReceiversDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 13/2/24.
//

import SwiftUI

struct ReceiversDetailView: View {
    
    @ObservedObject var payment: Payment
    
    var body: some View {
        List {
            ForEach($payment.enjoyersArray) { $enjoyer in
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
