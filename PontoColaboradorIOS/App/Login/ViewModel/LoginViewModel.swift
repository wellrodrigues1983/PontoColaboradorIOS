//
//  LoginViewModel.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 16/12/25.
//
// swift
import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    
    private let keychainService = "br.tec.wrcode"
    private let keychainAccount = "authToken"
    
    private var loginURL: URL {
        URL(string: "https://wrcode.tec.br/auth/login")!
    }
    
    // Validações
    var isEmailValid: Bool { !email.trimmed.isEmpty && email.isValidEmail }
    var emailValidationMessage: String? {
        if email.trimmed.isEmpty { return "Email é obrigatório." }
        if !email.isValidEmail { return "Email inválido." }
        return nil
    }
    
    var isPasswordValid: Bool { !password.trimmed.isEmpty && password.isValidPassword() }
    var passwordValidationMessage: String? {
        if password.trimmed.isEmpty { return "Senha é obrigatória." }
        if !password.isValidPassword() { return "Senha deve ter ao menos 6 caracteres." }
        return nil
    }
    
    var isFormValid: Bool { isEmailValid && isPasswordValid }
    
    // Login
    func login() async {
        errorMessage = nil
        
        guard isFormValid else {
            errorMessage = emailValidationMessage ?? passwordValidationMessage ?? "Preencha os campos corretamente."
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email.trimmed,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "Resposta inválida."
                return
            }
            
            if let authHeader = httpResponse.allHeaderFields["Authorization"] as? String {
                let saved = KeychainHelper.standard.save(authHeader, service: keychainService, account: keychainAccount)
                if !saved {
                    errorMessage = "Não foi possível salvar o token."
                    return
                }
                
                // Marca como autenticado para a UI (e persiste em UserDefaults para outras views)
                UserDefaults.standard.set(true, forKey: "isAuthenticated")
                isAuthenticated = true
            } else {
                let text = String(data: data, encoding: .utf8) ?? ""
                errorMessage = "Header Authorization não encontrado. Resposta: \(text)"
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func getStoredToken() -> String? {
        KeychainHelper.standard.readString(service: keychainService, account: keychainAccount)
    }
    
    func logout() {
        KeychainHelper.standard.delete(service: keychainService, account: keychainAccount)
        // limpa flag de autenticação
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        isAuthenticated = false
        email = ""
        password = ""
    }
}
