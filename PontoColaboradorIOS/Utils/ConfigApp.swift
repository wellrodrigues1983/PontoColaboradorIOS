//
//  ConfigApp.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 05/01/26.
//

import Foundation

public struct ConfigApp {
    public var title: String
    public var subtitle: String
    public var version: String
    private var production: Bool = false
    public var baseURL: URL
    
    public init() {
        title = "Título Padrão"
        subtitle = "Subtítulo Padrão"
        version = "1.0.0"
        let urlString = production ? "https://wrcode.tec.br" : "http://127.0.0.1:8080"
        guard let url = URL(string: urlString) else {
            fatalError("Invalid base URL: \(urlString)")
        }
        baseURL = url
    }
}
