//
//  HomeView.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 16/12/25.
//

import SwiftUI

struct HomeView: View {
    var onAction: () -> Void = { print("Ação do botão executada") }

    var body: some View {
        TabView {
            NavigationView {
                
                VStack(alignment: .center, spacing: 16) {
                    AnalogClockView()
                    DigitalClockView()
                    Button(action: onAction) {
                        Text("Registrar Ponto")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 220)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .accessibilityIdentifier("actionButton")
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding()
                
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
