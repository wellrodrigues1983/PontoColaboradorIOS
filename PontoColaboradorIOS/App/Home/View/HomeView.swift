//
//  HomeView.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 16/12/25.
//

import SwiftUI
import Combine

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    @State private var showSuccessAlert: Bool = false
    
    var onAction: (() -> Void)?
    
    var body: some View {
        TabView {
            NavigationView {
                
                VStack(alignment: .center, spacing: 16) {
                    AnalogClockView()
                    DigitalClockView()
                    Button(
                        action: {
                            let success = viewModel.savePonto()
                            if success {
                                showSuccessAlert = true
                            } else {
                                isAuthenticated = false
                            }
                        }
                    ) {
                        Text("Registrar Ponto")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 220)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .accessibilityIdentifier("actionButton")
                    .alert(isPresented: $showSuccessAlert) {
                        Alert(
                            title: Text("Sucesso"),
                            message: Text("Ponto registrado com sucesso!"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding()
                .ignoresSafeArea()
                
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            NavigationView {
                Text("Configurações")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.systemBackground))
                    .navigationTitle("Configurações")
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Configurações")
            }

            NavigationView {
                Text("Tarefas")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.systemBackground))
                    .navigationTitle("Tarefas")
            }
            .tabItem {
                Image(systemName: "checklist")
                Text("Tarefas")
            }
        }
    }
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
