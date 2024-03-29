//
//  ReceiversDetailView.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 13/2/24.
//

import SwiftUI

struct ReceiversDetailView: View {
    
    @ObservedObject var payment: Payment
    
    @State private var flag: Int = 0
    
    var body: some View {
        List {
            HStack {
                Text(payment.wName)
                Spacer()
                Text(String(format: "%.2f",payment.amount))
            }
            ForEach($payment.enjoyersArray) { $enjoyer in
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
        for enjoyer1 in payment.enjoyersArray {
            if (enjoyer1.bandera) {
                counter += 1
            }
        }
        for enjoyer2 in payment.enjoyersArray {
            if ((enjoyer2 == enjoyer && !enjoyer2.bandera && counter != 0) || (enjoyer2 != enjoyer &&  enjoyer2.bandera && counter != 0)) {
                enjoyer2.amount = payment.amount/Double(counter)
            } else {
                enjoyer2.amount = 0.0
            }
        }
    }
}
