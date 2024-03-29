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
    
    @State private var flag: Int = 0
    
    var body: some View {
        List {
            HStack {
                Text(newPaymentName)
                Spacer()
                Text(String(format: "%.2f",newPaymentAmount))
            }
            ForEach($newPaymentEnjoyers) { $enjoyer in
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
        for enjoyer1 in newPaymentEnjoyers {
            if (enjoyer1.bandera) {
                counter += 1
            }
        }
        for enjoyer2 in newPaymentEnjoyers {
            if ((enjoyer2 == enjoyer && !enjoyer2.bandera && counter != 0) || (enjoyer2 != enjoyer &&  enjoyer2.bandera && counter != 0)) {
                enjoyer2.amount = newPaymentAmount/Double(counter)
            } else {
                enjoyer2.amount = 0.0
            }
        }
    }
}
