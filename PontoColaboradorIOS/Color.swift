//
//  Color.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 17/12/25.
//

// swift
import SwiftUI
import UIKit

// Inicializadores a partir de string hex (#RRGGBB, RRGGBB ou AARRGGBB)
extension UIColor {
    convenience init(hex: String, defaultColor: UIColor = .clear) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") { hexString.removeFirst() }

        var alpha:   CGFloat = 1.0
        var red:     CGFloat = 0.0
        var green:   CGFloat = 0.0
        var blue:    CGFloat = 0.0

        let length = hexString.count
        let scanner = Scanner(string: hexString)
        var hexNumber: UInt64 = 0

        guard scanner.scanHexInt64(&hexNumber) else {
            self.init(cgColor: defaultColor.cgColor)
            return
        }

        if length == 6 {
            red   = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
            green = CGFloat((hexNumber & 0x00FF00) >> 8)  / 255.0
            blue  = CGFloat( hexNumber & 0x0000FF)        / 255.0
        } else if length == 8 {
            alpha = CGFloat((hexNumber & 0xFF000000) >> 24) / 255.0
            red   = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255.0
            green = CGFloat((hexNumber & 0x0000FF00) >> 8)  / 255.0
            blue  = CGFloat( hexNumber & 0x000000FF)        / 255.0
        } else {
            // Suporte básico a shorthand (RGB) como "FAB" -> "FFAABB"
            if length == 3 {
                let rChar = hexString[hexString.index(hexString.startIndex, offsetBy: 0)]
                let gChar = hexString[hexString.index(hexString.startIndex, offsetBy: 1)]
                let bChar = hexString[hexString.index(hexString.startIndex, offsetBy: 2)]
                let r = String([rChar, rChar])
                let g = String([gChar, gChar])
                let b = String([bChar, bChar])
                let full = r + g + b
                let scanner2 = Scanner(string: full)
                var num: UInt64 = 0
                if scanner2.scanHexInt64(&num) {
                    red   = CGFloat((num & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((num & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat( num & 0x0000FF)        / 255.0
                } else {
                    self.init(cgColor: defaultColor.cgColor); return
                }
            } else {
                self.init(cgColor: defaultColor.cgColor); return
            }
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension Color {
    init(hex: String, defaultColor: Color = .clear) {
        let ui = UIColor(hex: hex, defaultColor: UIColor(defaultColor))
        self.init(uiColor: ui)
    }
}

// Conveniência para criar UIColor a partir de SwiftUI Color (fallback para .clear se não existir)
fileprivate extension UIColor {
    convenience init(_ color: Color) {
        // Tenta extrair componentes via Mirror - fallback simples
        let uiColor = UIColor.clear
        self.init(cgColor: uiColor.cgColor)
    }
}

// Uso: cores estáticas do app usando hex
extension Color {
    static let appPrimary = Color(hex: "#19183B")
    static let appSecondary = Color(hex: "#708993")
    static let background = Color(hex: "#19183B")
    static let textPrimary = Color(hex: "#E7F2EF")
    static let accent = Color(hex: "#FF6B6B") // exemplo hex para Accent
    static let success = Color(hex: "#28A745")
    static let error = Color(hex: "#DC3545")
}

extension UIColor {
    static var appPrimary: UIColor { UIColor(hex: "#19183B") }
    static var appSecondary: UIColor { UIColor(hex: "#708993") }
    static var background: UIColor { UIColor(hex: "#19183B") }
    static var textPrimary: UIColor { UIColor(hex: "#E7F2EF") }
    static var accent: UIColor { UIColor(hex: "#FF6B6B") }
    static var success: UIColor { UIColor(hex: "#28A745") }
    static var error: UIColor { UIColor(hex: "#DC3545") }
}
