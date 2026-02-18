//
//  HomeViewModel.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 05/01/26.
//

import Foundation
internal import CoreData
import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {

    //Mark: - PROPERTIES
    @Published var pontos: [RegistroEntity] = []
    @Published var tipo: Bool = false
    @Published var successMessage: String? = nil
    @Published var errorQuantidade: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String? = nil
    @Published var alertTitle: String? = nil
    
    @AppStorage("email") var email: String?

    @AppStorage("isAuthenticated") var isAuthenticated: Bool?
    @AppStorage("token") var token: String?
    @AppStorage("photo") var photo: String?
    var imagePerfil: Image?

    private let persistence = PersistenceController.shared

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.timeZone = .current
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.timeZone = .current
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    //MARK: - INICIALIZADOR
    init(){
        self.pontos = (try? self.persistence.container.viewContext.fetch(RegistroEntity.fetchRequest())) ?? []
        
        //print("FOTO: \(self.photo ?? "NENHUMA")")
        
        //Removendo parametros iniciais do base64
        if let photo = self.photo, let commaIndex = photo.firstIndex(of: ",") {
            let base64Start = photo.index(after: commaIndex)
            let base64 = String(photo[base64Start...])
            // Convertendo o base64 em foto
            if let data = Data(base64Encoded: base64),
               let image = UIImage(data: data) {
                self.imagePerfil = Image(uiImage: image)
            }
        } 
        
    }

    func getPontos() -> [RegistroEntity] {
        return self.pontos
    }

    /// Retorna o início e o fim do dia para uma data específica
    private func dayBounds(for date: Date) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay) ?? date
        return (startOfDay, endOfDay)
    }

    private func countRegistrosNoDia(
        data: Date,
        //context: NSManagedObjectContext
    ) throws -> Int {
        let dateString = Self.dateFormatter.string(from: data)

        let request: NSFetchRequest<NSFetchRequestResult> =
            NSFetchRequest(entityName: "RegistroEntity")

        request.predicate = NSPredicate(
            format: "data == %@",
            dateString
        )

        return try persistence.container.viewContext.count(for: request)
    }

    /// Salva um novo ponto definindo a ordem do dia (1 a 4) com base na quantidade já existente
    @discardableResult
    func savePonto() -> Bool {
        let contexto = persistence.container.viewContext
        let agora = Date()
        let quantidadeHoje: Int
        do {
            quantidadeHoje = try countRegistrosNoDia(data: agora)
            if quantidadeHoje > 3 {
                //errorQuantidade = true
                self.showAlert = true
                self.alertMessage = "Limite diário de 4 pontos atingido."
                self.alertTitle = "Atenção"
                
                //print("Não é possível registrar mais de 4 pontos por dia.")
                return false
            }
        } catch {
            print("Erro ao contar registros do dia: \(error)")
            return false
        }
  
        let ordemDoDia = quantidadeHoje + 1

        let novoPonto = RegistroEntity(context: contexto)
        novoPonto.data = Self.dateFormatter.string(from: agora)  // Define a data atual como String
        novoPonto.hora = Self.timeFormatter.string(from: agora)  // Define a hora atual como String
        novoPonto.email = self.email  // Define o email do usuário atual

        if let attr = novoPonto.entity.attributesByName["ordemDoDia"], attr.attributeType == .integer16AttributeType {
            novoPonto.setValue(Int16(ordemDoDia), forKey: "ordemDoDia")
        }

        do {
            try contexto.save()
            fechPontos()
            self.showAlert = true
            self.alertTitle = "Sucesso"
            self.alertMessage = "Ponto registrado com sucesso!"
            return true
        } catch {
            print("Erro ao salvar ponto: \(error)")
            contexto.rollback()
            return false
        }
    }
    
    func fechPontos(){
            let contexto = persistence.container.viewContext
            let request = RegistroEntity.fetchRequest()
            request.predicate = NSPredicate(format: "data == %@", Self.dateFormatter.string(from: Date()))
            self.pontos = (try? contexto.fetch(request)) ?? []
        }
    
    func logout() {
        self.isAuthenticated = false
        self.email = nil
        self.token = nil
    }
    
    var profileImage44x44: Image? {
        guard let photoBase64 = self.photo,
              let data = Data(base64Encoded: photoBase64),
              let uiImage = UIImage(data: data) else {
            return nil
        }
        // Resize the UIImage to 44x44
        let size = CGSize(width: 44, height: 44)
        let renderer = UIGraphicsImageRenderer(size: size)
        let resized = renderer.image { _ in
            uiImage.draw(in: CGRect(origin: .zero, size: size))
        }
        return Image(uiImage: resized)
    }

}
