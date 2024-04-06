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
    @Binding var validPayer: Bool
    @Binding var validEnjoyer: Bool
    @Binding var validExpense: Bool
    @Binding var validPayment: Bool
    @Binding var theId: Int
    
    var body: some View {
        List {
            HStack {
                Text(newPaymentName)
                Spacer()
                Text(String(format: "%.2f",newPaymentAmount))
            }
            ForEach($newPaymentPayers) { $payer in
                HStack {
                    Toggle("",isOn: $payer.bandera.onChange({value in modificarAmount(payer: payer)}))
                        
                    Spacer()
                    Text(payer.toParticipant!.wName)
                    Spacer()
                    TextField("Amount", value: $payer.amount.onChange({value in validatePayer()}), format: .number)
                }
            }
        }
        .id(theId)
    }
    func modificarAmount(payer: Payer ) {
        var counter = 0
        theId += 1
        for payer1 in newPaymentPayers {
            if (payer1.bandera) {
                counter += 1
            }
        }
        if counter != 0 {
            for payer2 in newPaymentPayers {
                if (payer2.bandera) {
                    payer2.amount = newPaymentAmount/Double(counter)
                } else {
                    payer2.amount = 0.0
                }
            }
        } else {
            for payer2 in newPaymentPayers {
                payer2.amount = 0.0
            }
        }
        validatePayer()
    }
    func validatePayer() {
        var total = 0.0
        for newPaymentPayer in newPaymentPayers {
                total += newPaymentPayer.amount
        }
        if total == newPaymentAmount {
            validPayer = true
        } else {
            validPayer = false
        }
        if (validPayer && validEnjoyer) {
            validExpense = true
        } else {
            validExpense = false
        }
    }
}
