//
//  SendersDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 13/2/24.
//

import SwiftUI

struct SendersDetailView: View {
    
    @ObservedObject var payment: Payment
    
    @State private var flag: Int = 0
    
    var body: some View {
        List {
            HStack {
                Text(payment.wName)
                Spacer()
                Text(String(format: "%.2f",payment.amount))
            }
            ForEach($payment.payersArray) { $payer in
                HStack {
                    Toggle("",isOn: $payer.bandera)
                        .onTapGesture {
                            modificarAmount(payer: payer)
                        }
                    Spacer()
                    Text(payer.toParticipant!.wName)
                    Spacer()
                    TextField("Amount", value: $payer.amount, format: .number)
                }
            }
        }
        Text("\(flag)")
    }
    func modificarAmount(payer: Payer ) {
        var counter = 0
        flag += 1
        if (payer.bandera) {
            counter -= 1
        } else {
            counter += 1
        }
        for payer1 in payment.payersArray {
            if (payer1.bandera) {
                counter += 1
            }
        }
        for payer2 in payment.payersArray {
            if ((payer2 == payer && !payer2.bandera && counter != 0) || (payer2 != payer &&  payer2.bandera && counter != 0)) {
                payer2.amount = payment.amount/Double(counter)
            } else {
                payer2.amount = 0.0
            }
        }
    }
}
