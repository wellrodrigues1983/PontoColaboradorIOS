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
    @State private var showLimitAlert: Bool = false
    
    var onAction: (() -> Void)?
    
       
    var body: some View {
        TabView {
            NavigationView {
                
                //ScrollView {
                    VStack(alignment: .center, spacing: 16) {
                        AnalogClockView()
                        DigitalClockView()
                        Button(
                            action: {
                                let success = viewModel.savePonto()
                                if success {
                                    showSuccessAlert = true
                                } else if viewModel.errorQuantidade{
                                    showLimitAlert = true
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
                        }.alert(isPresented: $showLimitAlert) {
                            Alert(
                                title: Text("Limite de Registros"),
                                message: Text("Você atingiu o limite de registros para hoje."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                        
                        // Cards dinâmicos para registros
                        ScrollView{
                            
                            ForEach(viewModel.pontos.prefix(4), id: \.self) { ponto in
                                
                                HStack(alignment: .firstTextBaseline, spacing: 4) {
                                    Text("Registro \(ponto.ordemDoDia)")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text("Data: \(ponto.data ?? "N/A")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Hora: \(ponto.hora ?? "N/A")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            if viewModel.pontos.count == 4 {
                                Text("Apenas os 4 registros do dia são exibidos.")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 8)
                            }
                            
                        }.padding(.bottom, 20)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding()
                    .padding(.bottom, 50)
                //}
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
