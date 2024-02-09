//
//  Item.swift
//  SpenseSplit
//
//  Created by Pablo Penalva on 9/2/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
