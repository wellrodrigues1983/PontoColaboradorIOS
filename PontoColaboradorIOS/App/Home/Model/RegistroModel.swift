//
//  RegistroModel.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 05/01/26.
//

import Foundation

struct Registro: Codable, Identifiable {
    let id: UUID
    let date: String       // dd/MM/yyyy
    let time: String       // HH:mm:ss
    let userId: String
    let tipoRegistro: TipoRegistroEnum?
    var sent: Bool
    let createdAt: Date

//    init(userId: String, tipoRegistro?: TipoRegistroEnum? = nil) {
//        let date: Date? = Date()
//        self.id = UUID()
//        let df = DateFormatter()
//        df.dateFormat = "dd/MM/yyyy"
//        self.date = df.string(from: date)
//
//        let tf = DateFormatter()
//        tf.dateFormat = "HH:mm:ss"
//        self.time = tf.string(from: date)
//
//        self.userId = userId
//        self.tipoRegistro = tipoRegistro
//        self.sent = false
//        self.createdAt = date
//    }
}
