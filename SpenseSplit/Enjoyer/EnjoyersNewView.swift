//
//  EnjoyersNewView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 12/2/24.
//

import SwiftUI

struct EnjoyersNewView: View {
    
    @Binding var newExpenseName: String
    @Binding var newExpenseAmount: Double
    @Binding var newExpenseEnjoyers: [Enjoyer]
    @Binding var validPayer: Bool
    @Binding var validEnjoyer: Bool
    @Binding var validExpense: Bool
    @Binding var validPayment: Bool
    @Binding var theId: Int
    
    var body: some View {
        List {
            HStack {
                Text(newExpenseName)
                Spacer()
                Text(String(format: "%.2f",newExpenseAmount))
            }
            ForEach($newExpenseEnjoyers) { $enjoyer in
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
        for enjoyer1 in newExpenseEnjoyers {
            if (enjoyer1.bandera) {
                counter += 1
            }
        }
        if counter != 0 {
            for enjoyer2 in newExpenseEnjoyers {
                if (enjoyer2.bandera) {
                    enjoyer2.amount = newExpenseAmount/Double(counter)
                } else {
                    enjoyer2.amount = 0.0
                }
            }
        } else {
            for enjoyer2 in newExpenseEnjoyers {
                enjoyer2.amount = 0.0
            }
        }
        validateEnjoyer()
    }
    func validateEnjoyer() {
        var total = 0.0
        for newExpenseEnjoyer in newExpenseEnjoyers {
                total += newExpenseEnjoyer.amount
        }
        if total == newExpenseAmount {
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
