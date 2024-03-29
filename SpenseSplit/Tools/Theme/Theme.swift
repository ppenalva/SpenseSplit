//
//  Theme.swift
//  ScoreTrack
//
//  Created by Pablo Penalva on 14/1/23.
//

import SwiftUI

enum Theme: String,CaseIterable, Identifiable, Codable {
    
    case bubblegum
    case buttercup
    case lavender
    case navy
    case oxblood
    case periwinkle
    case poppy
    case seafoam
    case sky
    case tan
    
    var mainColor: Color {
        Color(rawValue)
    }
    var mainColorUI: UIColor {
        UIColor(Color(rawValue))
    }
    var nameColor: String {
        rawValue
    }
    var name: String {
        rawValue.capitalized
    }
    var id: String {
        name
    }


    func accentColor(color: String) -> Color {
        switch color {
        case "bubblegum" , "buttercup", "lavender", "periwinkle", "poppy", "seafoam", "sky", "tan" : return .black
        case "indigo", "navy", "oxblood" : return .white
        default: return .red
        }
    }
}
