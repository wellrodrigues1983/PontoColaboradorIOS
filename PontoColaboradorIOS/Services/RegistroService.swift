//
//  RegistroService.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 05/01/26.
//

// swift
import Foundation

final class RegistroService {
//    static let shared = RegistroService()
//    private let storage = LocalStorage.shared
//    private let session = URLSession.shared
//    private let endpoint = ConfigApp().baseURL

    private init() {}

    // Chame esta função quando o usuário clicar no botão
//    @MainActor
//    func registerPoint(userId: String) async {
//        let registro = Registro(userId: userId)
//        storage.append(registro) // salva local imediatamente
//        await uploadPending()    // tenta enviar pendentes
//    }

    // envia todos os registros não enviados
//    func uploadPending() async {
//        var registros = storage.load()
//        for index in registros.indices {
//            if registros[index].sent { continue }
//            do {
//                try await send(registros[index])
//                registros[index].sent = true
//                storage.save(registros)
//            } catch {
//                // falha ao enviar -> deixa como pendente para tentativa futura
//                print("uploadPending erro:", error)
//            }
//        }
//    }
//
//    private func send(_ registro: Registro) async throws {
//        var request = URLRequest(url: endpoint)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let body = try JSONEncoder().encode(registro)
//        let (_, response) = try await session.upload(for: request, from: body)
//        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
//            throw URLError(.badServerResponse)
//        }
//    }
}
