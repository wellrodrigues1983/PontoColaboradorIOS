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

    var onAction: (() -> Void)?

    var body: some View {
        TabView {
            HomeTabView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            SettingsTabView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Configurações")
                }

            TasksTabView()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Tarefas")
                }
        }
    }
}

struct HomeTabView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    @AppStorage("name") var name: String?
    @AppStorage("photo") var photo: String?
    
    
    var showAlert: Binding<Bool> {
        Binding<Bool>(
            get: { viewModel.showAlert },
            set: { viewModel.showAlert = $0 }
        )
    }
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center, spacing: 16) {
                Spacer()
                UserInfoView()
                AnalogClockView()
                DigitalClockView()
                ActionButtonView(viewModel: viewModel)
                Spacer()
                RecordsScrollView(viewModel: viewModel)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .padding(.bottom, 50)
            .ignoresSafeArea()
            .alert(isPresented: showAlert) {
                ShowAlert(message: viewModel.alertMessage ?? "Mesage", title: viewModel.alertTitle ?? "Title")
            }
        }
    }
    
    func ShowAlert(message: String, title: String) -> Alert {
            return Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: .default(Text("OK"))
            )
        }
}

struct ActionButtonView: View {
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        Button(
            action: {
                viewModel.savePonto()
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
    }
}

struct RecordsScrollView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            ForEach(Array(viewModel.pontos.prefix(4)), id: \RegistroEntity.objectID) { ponto in
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
        }
        .padding(.bottom, 20)
    }
}

struct SettingsTabView: View {
    var body: some View {
        NavigationView {
            Text("Configurações")
                .font(.title2)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
                .navigationTitle("Configurações")
        }
    }
}

struct TasksTabView: View {
    var body: some View {
        NavigationView {
            Text("Tarefas")
                .font(.title2)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
                .navigationTitle("Tarefas")
        }
    }
}

struct UserInfoView: View {
    @AppStorage("name") var name: String?
    @AppStorage("photo") var photo: String?
    
    var body: some View {
        HStack {
            Text("\(name ?? "Usuário")")
                .font(.system(size: 12, design: .default))
                .foregroundColor(.primary)
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(.primary)
            
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

