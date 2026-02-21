//
//  LoginResponse.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 19/01/26.
//

struct LoginResponse: Codable {
    let name: String?
    let email: String?
    let role: [String]?  // Mudança: agora é array
    let photo: String?
    var errorMessage: String?
    var success: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case role
        case photo
        case errorMessage
        case success
    }
}
