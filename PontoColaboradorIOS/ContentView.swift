//
//  ContentView.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 16/12/25.
//

// swift
import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
    }
    
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
//    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
//    @State private var showLogin: Bool = false

//    var body: some View {
//        NavigationView {
//            NavigationLink(destination: LoginView()) {
//                Text("Login")
//            }
//            VStack {
//                // Conteúdo da tela inicial quando autenticado
//                Text("Tela inicial do app")
//                    .font(.title)
//                    .padding()
//
//                // Exemplo de lista usando CoreData (se desejar)
//                List {
//                    ForEach(items) { item in
//                        Text(item.timestamp ?? Date(), style: .date)
//                    }
//                }
//            }
//            .navigationTitle("Início")
//        }
//        .onAppear {
//            // Sincroniza estado inicial com token no Keychain e com o AppStorage
//            let token = KeychainHelper.standard.readString(service: "br.tec.wrcode", account: "authToken")
//            isAuthenticated = (token != nil)
//            showLogin = !isAuthenticated
//        }
//        .onChange(of: isAuthenticated) { newValue in
//            // Quando autenticação mudar, atualiza apresentação do Login
//            showLogin = !newValue
//        }
//        .fullScreenCover(isPresented: $showLogin) {
//            LoginView()
//        }
//    }
}

#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
