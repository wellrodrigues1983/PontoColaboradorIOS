//
//  TipoRegistroEnum.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 05/01/26.
//

public enum TipoRegistroEnum: String, Codable {
    case entrada
    case almoço
    case almoçoRetorno
    case saída
    
    enum CodingKeys: String, CodingKey {
        case rawValue = "tipoRegistro"
    }
}
