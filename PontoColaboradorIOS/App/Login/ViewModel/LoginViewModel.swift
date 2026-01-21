//
//  LoginViewModelV2.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 20/01/26.
//

import Foundation
import Combine
internal import CoreData
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @AppStorage("isAuthenticated") var isAuthenticated: Bool?
    @AppStorage("token") var token: String?
    
    @Published var isAuth: Bool?

    private let httpService = HttpServices()

    private let persistence = PersistenceController.shared
    @Published var currentUser: CurrentUserEntity? = nil

    // MARK: - INICIALIZADOR
    init() {
        do {
            let request: NSFetchRequest<CurrentUserEntity> = CurrentUserEntity.fetchRequest()
            request.fetchLimit = 1
            self.currentUser = try persistence.container.viewContext.fetch(request).first
        } catch {
            self.currentUser = nil
        }

        if let tk = token {
            print("LoginViewModelV2 initialized. \(tk)")
            isAuthenticated = true
        } else {
            isAuthenticated = false
            print("Token not found")
        }

    }

    // MARK: - VALIDAÇÕES
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

    // MARK: - FUNÇÕES
    func doLogin() async -> Bool {
        errorMessage = nil
        isLoading = true

        let loginRequest = LoginRequest(email: email.trimmed, password: password.trimmed)

        do {
            let response = try await httpService.getLogin(loginRequest: loginRequest)
            self.isAuthenticated = true
            print("Login successful: \(response)")
            return true

        } catch {
            // Handle and surface error
            errorMessage = error.localizedDescription
            return false
        }

        isLoading = false
        return false
    }
       
    
}
