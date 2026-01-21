//
//  LoginRequest.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 19/01/26.
//

class LoginRequest: Codable {
    var email: String?
    var password: String?
    
    init(email: String?, password: String?) {
        self.email = email
        self.password = password
    }
}
