//
//  CustomButtonViewModifier.swift
//  CYOATemplate
//
//  Created by Judy YU on 2023-06-03.
//

import Foundation
import SwiftUI

// Adapted from: https://www.hackingwithswift.com/quick-start/swiftui/customizing-button-with-buttonstyle
// Button style
struct CustomButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .buttonStyle(.plain)
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .foregroundColor(.white)
            .background(configuration.isPressed ? .gray.opacity(0.2) : .black)
            .border(.white)
            .cornerRadius(6)
            .scaleEffect(configuration.isPressed ? 1.06 : 1)
    }
}
