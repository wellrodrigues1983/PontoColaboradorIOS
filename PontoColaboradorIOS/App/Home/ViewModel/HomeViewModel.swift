import Foundation
internal import CoreData
import Combine
import SwiftUI
import CoreLocation
import UIKit

final class HomeViewModel: ObservableObject {

    let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var currentLocation: CLLocation? = nil
    @Published private(set) var locationAuthorization: CLAuthorizationStatus = .notDetermined

    // MARK: - PROPERTIES
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

    // MARK: - INICIALIZADOR
    init(){
        self.pontos = (try? self.persistence.container.viewContext.fetch(RegistroEntity.fetchRequest())) ?? []

        // pedir permissão e observar updates
        locationManager.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loc in
                self?.currentLocation = loc
            }
            .store(in: &cancellables)

        processImage()
        
    }

    func getPontos() -> [RegistroEntity] {
        return self.pontos
    }

    private func dayBounds(for date: Date) -> (start: Date, end: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay) ?? date
        return (startOfDay, endOfDay)
    }

    private func countRegistrosNoDia(data: Date) throws -> Int {
        let dateString = Self.dateFormatter.string(from: data)
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "RegistroEntity")
        request.predicate = NSPredicate(format: "data == %@", dateString)
        return try persistence.container.viewContext.count(for: request)
    }

    @discardableResult
    func savePonto() -> Bool {
        let contexto = persistence.container.viewContext
        let agora = Date()
        let quantidadeHoje: Int
        do {
            quantidadeHoje = try countRegistrosNoDia(data: agora)
            if quantidadeHoje > 3 {
                self.showAlert = true
                self.alertMessage = "Limite diário de 4 pontos atingido."
                self.alertTitle = "Atenção"
                return false
            }
        } catch {
            print("Erro ao contar registros do dia: \(error)")
            return false
        }

        let ordemDoDia = quantidadeHoje + 1

        let novoPonto = RegistroEntity(context: contexto)
        novoPonto.data = Self.dateFormatter.string(from: agora)
        novoPonto.hora = Self.timeFormatter.string(from: agora)
        novoPonto.email = self.email

        // não trava: salva mesmo sem localização; usa 0.0 como valor padrão
        let lat = currentLocation?.coordinate.latitude ?? 0.0
        let lon = currentLocation?.coordinate.longitude ?? 0.0
        novoPonto.latitude = lat
        novoPonto.longitude = lon

        if currentLocation == nil {
            self.showAlert = true
            self.alertTitle = "Localização indisponível"
            self.alertMessage = "Ponto salvo sem coordenadas. Habilite localização nas configurações para registrar coordenadas."
        }

        if let attr = novoPonto.entity.attributesByName["ordemDoDia"], attr.attributeType == .integer16AttributeType {
            novoPonto.setValue(Int16(ordemDoDia), forKey: "ordemDoDia")
        }

        // evita problemas com aspas internas usando variáveis temporárias
        let dataStr = novoPonto.data ?? "-"
        let horaStr = novoPonto.hora ?? "-"
        let emailStr = novoPonto.email ?? "-"

        print("Data: \(dataStr)")
        print("Hora: \(horaStr)")
        print("Email: \(emailStr)")
        print("Latitude: \(novoPonto.latitude)")
        print("Longitude: \(novoPonto.longitude)")
        print("Ordem do Dia: \(novoPonto.ordemDoDia)")

        do {
            try contexto.save()
            fechPontos()
            if self.alertTitle != "Localização indisponível" {
                self.showAlert = true
                self.alertTitle = "Sucesso"
                self.alertMessage = "Ponto registrado com sucesso!"
            }
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
        self.photo = nil
    }

    func processImage(){
        // Removendo parametros iniciais do base64
        if let photo = self.photo, let commaIndex = photo.firstIndex(of: ",") {
            let base64Start = photo.index(after: commaIndex)
            let base64 = String(photo[base64Start...])
            if let data = Data(base64Encoded: base64),
               let image = UIImage(data: data) {
                self.imagePerfil = Image(uiImage: image)
            }
        }
    }
   
}
