//
//  PayersNewView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 12/2/24.
//

import SwiftUI

struct PayersNewView: View {
    
    @Binding var newExpenseName: String
    @Binding var newExpenseAmount: Double
    @Binding var newExpensePayers: [Payer]
    
    @State var flag: Int = 0
    
    var body: some View {
        List {
            HStack {
                Text(newExpenseName)
                Spacer()
                Text(String(format: "%.2f",newExpenseAmount))
            }
            ForEach($newExpensePayers) { $payer in
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
        for payer1 in newExpensePayers {
            if (payer1.bandera) {
                counter += 1
            }
        }
        for payer2 in newExpensePayers {
            if ((payer2 == payer && !payer2.bandera && counter != 0) || (payer2 != payer &&  payer2.bandera && counter != 0)) {
                payer2.amount = newExpenseAmount/Double(counter)
            } else {
                payer2.amount = 0.0
            }
        }
    }
}
