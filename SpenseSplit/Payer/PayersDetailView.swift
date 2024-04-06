//
//  PayersDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 12/2/24.
//

import SwiftUI

struct PayersDetailView: View {
    
    @ObservedObject var expense: Expense
    @Binding var validPayer: Bool
    @Binding var validEnjoyer: Bool
    @Binding var validExpense: Bool
    @Binding var validPayment: Bool
    @Binding var theId: Int
    
    var body: some View {
        List {
            HStack {
                Text(expense.wName)
                Spacer()
                Text(String(format: "%.2f",expense.amount))
            }
            ForEach($expense.payersArray) { $payer in
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
        for payer1 in expense.payersArray {
            if (payer1.bandera) {
                counter += 1
            }
        }
        if counter != 0 {
            for payer2 in expense.payersArray {
                if (payer2.bandera) {
                    payer2.amount = expense.amount/Double(counter)
                } else {
                    payer2.amount = 0.0
                }
            }
        } else {
            for payer2 in expense.payersArray {
                payer2.amount = 0.0
            }
        }
        validatePayer()
    }
    func validatePayer() {
        validEnjoyer = true
        var total = 0.0
        for newExpensePayer in expense.payersArray {
            total += newExpensePayer.amount
        }
        if total == expense.amount {
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
