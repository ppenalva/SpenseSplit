//
//  ReceiverNewView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 12/2/24.
//

import SwiftUI

struct ReceiversNewView: View {
    
    @Binding var newPaymentName: String
    @Binding var newPaymentAmount: Double
    @Binding var newPaymentEnjoyers: [Enjoyer]
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
            ForEach($newPaymentEnjoyers) { $enjoyer in
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
        for enjoyer1 in newPaymentEnjoyers {
            if (enjoyer1.bandera) {
                counter += 1
            }
        }
        if counter != 0 {
            for enjoyer2 in newPaymentEnjoyers {
                if (enjoyer2.bandera) {
                    enjoyer2.amount = newPaymentAmount/Double(counter)
                } else {
                    enjoyer2.amount = 0.0
                }
            }
        } else {
            for enjoyer2 in newPaymentEnjoyers {
                enjoyer2.amount = 0.0
            }
        }
        validateEnjoyer()
    }
    func validateEnjoyer() {
        var total = 0.0
        for newPaymentEnjoyer in newPaymentEnjoyers {
                total += newPaymentEnjoyer.amount
        }
        if total == newPaymentAmount {
            validEnjoyer = true
        } else {
            validEnjoyer = false
        }
        if (validPayer && validEnjoyer) {
            validExpense = true
        } else {
            validExpense = false
        }
    }
}
