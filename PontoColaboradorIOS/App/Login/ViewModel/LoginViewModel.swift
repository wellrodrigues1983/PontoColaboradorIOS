//
//  LoginViewModel.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 16/12/25.
//
// swift
import Foundation
import Combine
import CoreData

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    
    private let keychainService = "br.tec.wrcode"
    private let keychainAccount = "authToken"
    private var production = false
    private var app: ConfigApp?
    

    let container: NSPersistentContainer
    private let persistence = PersistenceController.shared
    @Published var currentUser: CurrentUserEntity? = nil
    
    init(){
        container = NSPersistentContainer(name: "PontoColaboradorIOS")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        do {
            let request: NSFetchRequest<CurrentUserEntity> = CurrentUserEntity.fetchRequest()
            request.fetchLimit = 1
            self.currentUser = try container.viewContext.fetch(request).first
        } catch {
            self.currentUser = nil
        }
        
        app = ConfigApp()
    }
    
    private var loginURL: URL {
        URL(string: (app?.baseURL.absoluteString)! + "/auth/login")!
    }
    
    private var tokenURL: URL {
        URL(string: (app?.baseURL.absoluteString)! + "/auth/check")!
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
                
                saveCurrentUser(email: email.trimmed)
                
                if !saved {
                    errorMessage = "Não foi possível salvar o token."
                    return
                }
                
                // Marca como autenticado para a UI (e persiste em UserDefaults para outras views)
                UserDefaults.standard.set(true, forKey: "isAuthenticated")
                isAuthenticated = true
            } else {
                let text = String(data: data, encoding: .utf8) ?? ""
                errorMessage = "Não foi possivel realizar o Login. Resposta: \(text)"
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
    
    func verifyStoredToken() async {
        // Verifica se há token armazenado
        guard let token = getStoredToken() else {
            // Sem token armazenado: marca como não autenticado
            DispatchQueue.main.async {
                self.isAuthenticated = false
                UserDefaults.standard.set(false, forKey: "isAuthenticated")
            }
          
            return
        }

        // Opcional: aqui poderíamos validar localmente caso fosse JWT (código comentado abaixo)
        let serverOk = await validateTokenWithServer(token)
        if serverOk {
            DispatchQueue.main.async {
                self.isAuthenticated = true
                UserDefaults.standard.set(true, forKey: "isAuthenticated")
            }
            return
        } else {
            // Token inválido no servidor -> remover e marcar como não autenticado
            KeychainHelper.standard.delete(service: keychainService, account: keychainAccount)
            DispatchQueue.main.async {
                self.isAuthenticated = false
                UserDefaults.standard.set(false, forKey: "isAuthenticated")
            }
        }
    }
    
    // Validação via servidor (endpoint de verificação)
    func validateTokenWithServer(_ token: String) async -> Bool {
        //guard let url = URL(string: tokeUrl) else { return false }
        var req = URLRequest(url: tokenURL)
        req.httpMethod = "GET"
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do {
            let (_, resp) = try await URLSession.shared.data(for: req)
            if let http = resp as? HTTPURLResponse {
                return http.statusCode == 200
            }
        } catch {
            return false
        }
        return false
    }
    
    func saveCurrentUser(email: String) {
        let ctx = persistence.container.newBackgroundContext()
        ctx.perform {
            // If you want only one CurrentUserEntity, clear existing ones first
            let fetch: NSFetchRequest<NSFetchRequestResult> = CurrentUserEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                try ctx.execute(deleteRequest)
            } catch {
                // Ignore if no records; proceed to create a new one
            }

            let user = CurrentUserEntity(context: ctx)
            user.email = email
            do {
                try ctx.save()
                // Refresh currentUser on main context
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    do {
                        let request: NSFetchRequest<CurrentUserEntity> = CurrentUserEntity.fetchRequest()
                        request.fetchLimit = 1
                        self.currentUser = try self.container.viewContext.fetch(request).first
                    } catch {
                        self.currentUser = nil
                    }
                }
            } catch {
                // Optionally publish an error
                DispatchQueue.main.async { [weak self] in
                    self?.errorMessage = "Falha ao salvar usuário: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func fetchCurrentUsers() -> [CurrentUserEntity] {
        let request: NSFetchRequest<CurrentUserEntity> = CurrentUserEntity.fetchRequest()
        do {
            return try container.viewContext.fetch(request)
        } catch {
            self.errorMessage = "Falha ao listar usuários: \(error.localizedDescription)"
            return []
        }
    }

    func fetchCurrentUser(byEmail email: String) -> CurrentUserEntity? {
        let request: NSFetchRequest<CurrentUserEntity> = CurrentUserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email ==[c] %@", email)
        request.fetchLimit = 1
        do {
            return try container.viewContext.fetch(request).first
        } catch {
            self.errorMessage = "Falha ao buscar usuário: \(error.localizedDescription)"
            return nil
        }
    }

    func deleteCurrentUser(_ user: CurrentUserEntity) {
        let ctx = container.viewContext
        ctx.delete(user)
        do {
            try ctx.save()
            // Update published state
            if self.currentUser == user {
                self.currentUser = nil
            }
        } catch {
            self.errorMessage = "Falha ao deletar usuário: \(error.localizedDescription)"
        }
    }
    func deleteAllCurrentUsers() {
        let ctx = container.viewContext
        let fetch: NSFetchRequest<NSFetchRequestResult> = CurrentUserEntity.fetchRequest()
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try ctx.execute(request)
            try ctx.save()
            self.currentUser = nil
        } catch {
            self.errorMessage = "Falha ao deletar todos os usuários: \(error.localizedDescription)"
        }
    }
}

