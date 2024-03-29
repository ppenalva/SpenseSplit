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
    
    @State private var flag: Int = 0
    
    var body: some View {
        List {
            HStack {
                Text(newExpenseName)
                Spacer()
                Text(String(format: "%.2f",newExpenseAmount))
            }
            ForEach($newExpenseEnjoyers) { $enjoyer in
                HStack {
                    Toggle("",isOn: $enjoyer.bandera)
                        .onTapGesture {
                            modificarAmount(enjoyer: enjoyer)
                        }
                    Spacer()
                    Text(enjoyer.toParticipant!.wName)
                    Spacer()
                    TextField("Amount", value: $enjoyer.amount, format: .number)
                }
            }
        }
        Text("\(flag)")
    }
    func modificarAmount(enjoyer: Enjoyer ) {
        var counter = 0
        flag += 1
        if (enjoyer.bandera) {
            counter -= 1
        } else {
            counter += 1
        }
        for enjoyer1 in newExpenseEnjoyers {
            if (enjoyer1.bandera) {
                counter += 1
            }
        }
        for enjoyer2 in newExpenseEnjoyers {
            if ((enjoyer2 == enjoyer && !enjoyer2.bandera && counter != 0) || (enjoyer2 != enjoyer &&  enjoyer2.bandera && counter != 0)) {
                enjoyer2.amount = newExpenseAmount/Double(counter)
            } else {
                enjoyer2.amount = 0.0
            }
        }
    }
}
