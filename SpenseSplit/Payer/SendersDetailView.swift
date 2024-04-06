//
//  SendersDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 13/2/24.
//

import SwiftUI

struct SendersDetailView: View {
    
    @ObservedObject var payment: Payment
    @Binding var validPayer: Bool
    @Binding var validEnjoyer: Bool
    @Binding var validExpense: Bool
    @Binding var validPayment: Bool
    @Binding var theId: Int
    
    var body: some View {
        List {
            HStack {
                Text(payment.wName)
                Spacer()
                Text(String(format: "%.2f",payment.amount))
            }
            ForEach($payment.payersArray) { $payer in
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
        for payer1 in payment.payersArray {
            if (payer1.bandera) {
                counter += 1
            }
        }
        if counter != 0 {
            for payer2 in payment.payersArray {
                if (payer2.bandera) {
                    payer2.amount = payment.amount/Double(counter)
                } else {
                    payer2.amount = 0.0
                }
            }
        } else {
            for payer2 in payment.payersArray {
                payer2.amount = 0.0
            }
        }
        validatePayer()
    }
    func validatePayer() {
        validEnjoyer = true
        var total = 0.0
        for newPaymentPayer in payment.payersArray {
                total += newPaymentPayer.amount
        }
        if total == payment.amount {
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
