//
//  SenderNewView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 12/2/24.
//

import SwiftUI

struct SendersNewView: View {
    
    @Binding var newPaymentName: String
    @Binding var newPaymentAmount: Double
    @Binding var newPaymentPayers: [Payer]
    
    @State private var flag: Int = 0
    
    var body: some View {
        List {
            HStack {
                Text(newPaymentName)
                Spacer()
                Text(String(format: "%.2f",newPaymentAmount))
            }
            ForEach($newPaymentPayers) { $payer in
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
        for payer1 in newPaymentPayers {
            if (payer1.bandera) {
                counter += 1
            }
        }
        for payer2 in newPaymentPayers {
            if ((payer2 == payer && !payer2.bandera && counter != 0) || (payer2 != payer &&  payer2.bandera && counter != 0)) {
                payer2.amount = newPaymentAmount/Double(counter)
            } else {
                payer2.amount = 0.0
            }
        }
    }
}
