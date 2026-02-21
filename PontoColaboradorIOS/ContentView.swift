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
    //@State private var isLoggedIn: Bool?
    @AppStorage("isAuthenticated") var isLoggedIn: Bool?
    @AppStorage("token") var token: String = ""
    @AppStorage("name") var name: String?
    @AppStorage("email") var email: String?
    @AppStorage("photo") var photo: String?
    
    var service = HttpServices()

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
        let isValid = await service.validateToken(token)
        if isValid && name != nil && email != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
