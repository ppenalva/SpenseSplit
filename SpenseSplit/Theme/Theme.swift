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
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case poppy
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow
    
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
        case "bubblegum" , "buttercup", "lavender", "orange", "periwinkle", "poppy", "seafoam", "sky", "tan", "teal", "yellow" : return .black
        case "indigo", "magenta", "navy", "oxblood", "purple" : return .white
        default: return .red
        }
    }
}
