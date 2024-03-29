//
//  ThemePicker.swift
//  ScoreTrack
//
//  Created by Pablo Penalva on 14/1/23.
//

import SwiftUI
import UIKit

struct ThemePicker: View {
    
    @Binding var selection: String
    
    var body: some View {
        Picker("Theme", selection: $selection) {
            Text("").tag("")
            ForEach(Theme.allCases) { theme in
                HStack {
                    Image(uiImage: colorSwatchImage(color: theme.mainColorUI)
                   )
                    Text(theme.name)
                }.tag(theme.nameColor)
            }
                    .pickerStyle(.menu)
        }
    }
    private func colorSwatchImage(color: UIColor) -> UIImage {
        let size = CGSize(width: 24  , height: 12)
        let rect = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image(actions: { context in
            color.setFill()
            UIBezierPath(roundedRect: rect, cornerRadius: 4).fill()
        })
    }
}
                          
extension UIColor {
    static func color(name:String) -> UIColor? {
        let selector = Selector("\(name)Color")
        if UIColor.self.responds(to: selector) {
            let color = UIColor.self.perform(selector).takeUnretainedValue()
            return (color as? UIColor)
        } else {
            return nil
        }
    }
}
