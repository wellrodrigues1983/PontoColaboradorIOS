//
//  ClockHand.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 05/01/26.
//

import SwiftUI

struct ClockHand: View {
    var length: CGFloat
    var thickness: CGFloat
    var color: Color = .primary
    var angle: Angle

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: thickness, height: length)
            .cornerRadius(thickness / 2)
            .offset(y: -length / 2)
            .rotationEffect(angle)
            .shadow(color: Color.black.opacity(0.08), radius: thickness)
            .accessibilityHidden(true)
    }
}
