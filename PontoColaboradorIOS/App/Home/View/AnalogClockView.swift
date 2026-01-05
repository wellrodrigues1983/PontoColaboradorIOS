//
//  AnalogClockView.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 05/01/26.
//

import SwiftUI
import Combine

struct AnalogClockView: View {
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                Circle()
                    .fill(Color(UIColor.systemBackground))
                Circle()
                    .stroke(Color.primary.opacity(0.12), lineWidth: size * 0.02)

                ForEach(0..<60) { i in
                    Rectangle()
                        .fill(i % 5 == 0 ? Color.primary : Color.primary.opacity(0.5))
                        .frame(
                            width: i % 5 == 0 ? size * 0.02 : size * 0.004,
                            height: i % 5 == 0 ? size * 0.09 : size * 0.04
                        )
                        .offset(y: -(size / 2) + (i % 5 == 0 ? size * 0.045 : size * 0.02))
                        .rotationEffect(.degrees(Double(i) * 6))
                }

                ClockHand(length: size * 0.38, thickness: size * 0.012, color: .red, angle: secondAngle(date: now))
                ClockHand(length: size * 0.32, thickness: size * 0.018, color: .primary, angle: minuteAngle(date: now))
                ClockHand(length: size * 0.24, thickness: size * 0.028, color: .primary, angle: hourAngle(date: now))

                Circle()
                    .fill(Color.primary)
                    .frame(width: size * 0.05, height: size * 0.05)
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
            
            
        }
        .aspectRatio(1, contentMode: .fit)
        .onReceive(timer) { input in
            withAnimation(.linear(duration: 1)) {
                now = input
            }
        }.padding()
        
        
    }

    // ângulos monótonicos (crescentes) — sem aplicar modulo 360
    private func secondAngle(date: Date) -> Angle {
        // 6 graus por segundo
        return .degrees(date.timeIntervalSince1970 * 6.0)
    }

    private func minuteAngle(date: Date) -> Angle {
        // 6 graus por minuto => 6 / 60 = 0.1 graus por segundo
        return .degrees(date.timeIntervalSince1970 * 0.1)
    }

    private func hourAngle(date: Date) -> Angle {
        // 30 graus por hora => 30 / 3600 = 0.008333... graus por segundo
        return .degrees(date.timeIntervalSince1970 * (30.0 / 3600.0))
    }
}
