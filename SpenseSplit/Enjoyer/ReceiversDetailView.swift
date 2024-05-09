//
//  ReceiversDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 13/2/24.
//

import SwiftUI

struct ReceiversDetailView: View {
    
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
            ForEach($payment.enjoyersArray) { $enjoyer in
                HStack {
                    Toggle("",isOn: $enjoyer.bandera.onChange({value in modificarAmount(enjoyer: enjoyer)}))
                    Spacer()
                    Text(enjoyer.toParticipant!.wName)
                    Spacer()
                    TextField("Amount", value: $enjoyer.amount.onChange({value in validateEnjoyer()}), format: .number)
                }
            }
        }
        .id(theId)
    }
    func modificarAmount(enjoyer: Enjoyer ) {
        var counter = 0
        theId += 1
        for enjoyer1 in payment.enjoyersArray {
            if (enjoyer1.bandera) {
                counter += 1
            }
        }
        if counter != 0 {
            for enjoyer2 in payment.enjoyersArray {
                if (enjoyer2.bandera) {
                    enjoyer2.amount = payment.amount/Double(counter)
                } else {
                    enjoyer2.amount = 0.0
                }
            }
        } else {
            for enjoyer2 in payment.enjoyersArray {
                enjoyer2.amount = 0.0
            }
        }
        validateEnjoyer()
    }
    func validateEnjoyer() {
        validPayer = true
        var total = 0.0
        for newPaymentEnjoyer in payment.enjoyersArray {
                total += newPaymentEnjoyer.amount
        }
        if total == payment.amount {
            validEnjoyer = true
        } else {
            validEnjoyer = false
        }
        if (validPayer && validEnjoyer) {
            validPayment = true
        } else {
            validPayment = false
        }
    }
}

