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
            HStack {
                Text(expense.wName)
                Spacer()
                Text(String(format: "%.2f",expense.amount))
            }
            ForEach($expense.payersArray) { $payer in
                HStack {
                    Toggle(isOn: $payer.bandera){}
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
    }
    func modificarAmount(payer: Payer ) {
        var counter = 0
        if (payer.bandera) {
            counter -= 1
        } else {
            counter += 1
        }
        for payer1 in expense.payersArray {
            if (payer1.bandera) {
                counter += 1
            }
        }
        for payer2 in expense.payersArray {
            if ((payer2 == payer && !payer2.bandera && counter != 0) || (payer2 != payer &&  payer2.bandera && counter != 0)) {
                payer2.amount = expense.amount/Double(counter)
            } else {
                payer2.amount = 0.0
            }
        }
    }
}
