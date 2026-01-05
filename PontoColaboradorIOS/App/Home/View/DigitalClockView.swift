//
//  DigitalClockView.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 05/01/26.
//

import SwiftUI
import Combine

struct DigitalClockView: View {
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f
    }()

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()

    var body: some View {
        VStack(spacing: 8) {
            Text(Self.timeFormatter.string(from: now))
                .font(.system(size: 56, weight: .bold, design: .monospaced))
                .monospacedDigit()
                .foregroundColor(.primary)

            Text(Self.dateFormatter.string(from: now))
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
        }
        .onReceive(timer) { input in
            now = input
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Relógio digital")
        .accessibilityValue("\(Self.timeFormatter.string(from: now)), \(Self.dateFormatter.string(from: now))")
    }
}
