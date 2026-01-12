//
//  PontoColaboradorIOSApp.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 16/12/25.
//

//import SwiftUI
//import CoreData
//
//@main
//struct PontoColaboradorIOSApp: App {
//    let persistenceController = PersistenceController.shared
//    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
//
//
//    var body: some Scene {
//        WindowGroup {
//            if isAuthenticated {
//                HomeView()
//            } else {
//                LoginView()
//                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            }
//
//        }
//    }
//}

import SwiftUI

@main
struct PontoColaboradorIOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
