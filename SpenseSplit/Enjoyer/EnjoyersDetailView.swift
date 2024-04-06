//
//  EnjoyersDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 12/2/24.
//

import SwiftUI

struct EnjoyersDetailView: View {
    
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
            ForEach($expense.enjoyersArray) { $enjoyer in
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
        for enjoyer1 in expense.enjoyersArray {
            if (enjoyer1.bandera) {
                counter += 1
            }
        }
        if counter != 0 {
            for enjoyer2 in expense.enjoyersArray {
                if (enjoyer2.bandera) {
                    enjoyer2.amount = expense.amount/Double(counter)
                } else {
                    enjoyer2.amount = 0.0
                }
            }
        } else {
            for enjoyer2 in expense.enjoyersArray {
                enjoyer2.amount = 0.0
            }
        }
        validateEnjoyer()
    }
        func validateEnjoyer() {
            validPayer = true
            var total = 0.0
            for newExpenseEnjoyer in expense.enjoyersArray {
                    total += newExpenseEnjoyer.amount
            }
            if total == expense.amount {
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

