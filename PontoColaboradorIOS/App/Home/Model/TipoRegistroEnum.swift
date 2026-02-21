//
//  TipoRegistroEnum.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 05/01/26.
//

public enum TipoRegistroEnum: String, Codable {
    case ENTRADA
    case INTERVALO_INICIO
    case INTERVALO_FIM
    case SAIDA

    
    enum CodingKeys: String, CodingKey {
        case rawValue = "tipoRegistro"
    }
}
