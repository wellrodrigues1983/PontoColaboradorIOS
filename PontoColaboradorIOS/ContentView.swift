//
//  ContentView.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 16/12/25.
//

import SwiftUI
internal import CoreData

struct ContentView: View {
    let persistenceController = PersistenceController.shared
    @State private var isLoggedIn: Bool?

    var body: some View {
        Group {
            if let isLoggedIn = isLoggedIn {
                if isLoggedIn {
                    HomeView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                } else {
                    LoginView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            } else {
                LoginView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
        .onAppear {
            Task {
                await checkAuthentication()
            }
        }
    }

    private func checkAuthentication() async {
        let keychainService = "br.tec.wrcode"
        let keychainAccount = "authToken"
        guard let token = KeychainHelper.standard.readString(service: keychainService, account: keychainAccount) else {
            isLoggedIn = false
            return
        }
        let isValid = await validateToken(token)
        isLoggedIn = isValid
    }

    private func validateToken(_ token: String) async -> Bool {
        let tokenURL = URL(string: "https://your-api-url/auth/check")! // Substitua pela URL real
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
