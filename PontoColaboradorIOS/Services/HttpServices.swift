//
//  HttpServices.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 19/01/26.
//

import Foundation
import SwiftUI

class HttpServices {
    
    @AppStorage("isAuthenticated") var isAuthenticated: Bool?
    @AppStorage("name") var name: String?
    @AppStorage("email") var email: String?
    @AppStorage("photo") var photo: String?
    @AppStorage("role") var role: String?
    
    @AppStorage("token") var token: String?
       
    var production: Bool = false
    
    var urlString: String {
        self.production ? "https://wrcode.tec.br" : "http://192.168.68.53:8080"
    }
    
    func validateToken(_ token: String) async -> Bool {
        print("Validating token... \(token)")
        
        var result : Bool = false
        
        guard let tokenStored = token as String? else {
            return false
        }
        
        guard let tokenURL = URL(string: urlString + "/auth/check") else { return false }
        var req = URLRequest(url: tokenURL)
        req.httpMethod = "GET"
        req.setValue("Bearer \(tokenStored)", forHTTPHeaderField: "Authorization")
        do {
            let (_, resp) = try await URLSession.shared.data(for: req)
            if let http = resp as? HTTPURLResponse {
                
                if http.statusCode == 200 {
                    print("Token validation response code: \(http.statusCode)")
                    result = true
                }
                
                if http.statusCode == 401 {
                    print("Token is invalid or expired.")
                    self.token = nil
                    self.isAuthenticated = false
                    result = false
                }
                                
                return result
            } else {
                self.token = nil
            }
            
        } catch {
            return result
        }
        return result
    }
    
    func getLogin(loginRequest: LoginRequest) async -> LoginResponse {
        
        var loginResponse = LoginResponse(name: nil, email: nil, role: nil, photo: nil, errorMessage: nil, success: false)
        
        guard let url = URL(string: urlString + "/auth/login") else {
            loginResponse.errorMessage = "URL inválida"
            return loginResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(loginRequest)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                loginResponse.errorMessage = "Resposta inválida do servidor"
                return loginResponse
            }
            
            if httpResponse.statusCode == 401 {
                loginResponse.success = false
                loginResponse.errorMessage = "Usuário ou senha inválido."
                return loginResponse
            }
            
            if httpResponse.statusCode == 200 {
                if let authHeader = httpResponse.allHeaderFields["Authorization"] as? String {
                    token = authHeader
                    
                    let body = try JSONDecoder().decode(LoginResponse.self, from: data)
                    
                    // Atualiza @AppStorage
                    self.name = body.name
                    self.email = body.email
                    self.photo = body.photo
                    self.role = body.role?.first
                    
                    // Retorna o objeto decodificado
                    return body
                } else {
                    loginResponse.errorMessage = "Token de autorização não encontrado"
                    return loginResponse
                }
            } else {
                loginResponse.errorMessage = "Erro no servidor: \(httpResponse.statusCode)"
                return loginResponse
            }
        } catch let DecodingError.keyNotFound(key, context) {
            print("Chave não encontrada: \(key.stringValue)")
            print("Context: \(context)")
            loginResponse.errorMessage = "Erro ao processar resposta do servidor"
            return loginResponse
        } catch {
            print("Error: \(error.localizedDescription)")
            loginResponse.errorMessage = "Ocorreu um erro ao tentar fazer login."
            return loginResponse
        }
    }
    
}

enum LoginError: Error {
    case invalidCredentials
    case serverError
}
