//
//  RecoverPasswordViewModel.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 16/12/25.
//

import Foundation
import Combine

@MainActor
final class RecoverPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private var recoveryURL: URL {
        // ajuste para o endpoint correto da sua API
        URL(string: "http://wrcode.tec.br:4871/auth/forgot-password")!
    }

    var isEmailValid: Bool { !email.trimmed.isEmpty && email.isValidEmail }
    var emailValidationMessage: String? {
        if email.trimmed.isEmpty { return "Email é obrigatório." }
        if !email.isValidEmail { return "Email inválido." }
        return nil
    }

    func sendRecovery() async {
        errorMessage = nil
        successMessage = nil

        guard isEmailValid else {
            errorMessage = emailValidationMessage
            return
        }

        isLoading = true
        defer { isLoading = false }

        var request = URLRequest(url: recoveryURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email.trimmed]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Resposta inválida do servidor."
                return
            }

            switch httpResponse.statusCode {
            case 200, 201, 204:
                // resposta bem-sucedida — mensagem genérica para o usuário
                successMessage = "Se o email existir, enviamos instruções para redefinir a senha."
            default:
                // tenta extrair mensagem do corpo
                let text = String(data: data, encoding: .utf8) ?? "Erro desconhecido."
                errorMessage = "Erro \(httpResponse.statusCode): \(text)"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
