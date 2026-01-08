//
//  LoginView.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 16/12/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isSecured: Bool = true
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    
    var body: some View {
        ZStack {
            Color.appPrimary.edgesIgnoringSafeArea(.all) // Background color
            
            VStack(spacing: 20) {
                Spacer()
                
                VStack(spacing: 10) {
                    Image("brainPontoLogo")
                        .frame(width: 320, height: 320)
                    
                    Text("Login")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 198/255, green: 155/255, blue: 82/255))
                }
                
                VStack(spacing: 5) {
                    Text("Bem-vindo de volta!")
                        .font(.headline)
                        .foregroundColor(Color(red: 255/255, green: 220/255, blue: 193/255))
                    Text("Entre para registrar seu ponto.")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 255/255, green: 220/255, blue: 193/255))
                }
                .padding(.bottom, 20)
                
                // Input Fields
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        TextField("Matrícula ou E-mail", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                    }
                    .padding()
                    .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                    .cornerRadius(10)
                    
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        if isSecured {
                            SecureField("Senha", text: $viewModel.password)
                        } else {
                            TextField("Senha", text: $viewModel.password)
                        }
                        Button(action: {
                            isSecured.toggle()
                        }) {
                            Image(systemName: isSecured ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                    .cornerRadius(10)
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        //TODO : Implement forgot password action
                    }) {
                        Text("Esqueci minha senha")
                            .font(.footnote)
                            .foregroundColor(Color(red: 255/255, green: 220/255, blue: 193/255))
                    }
                }
                
                // Login Button
                Button(action: {
                    Task { await viewModel.login() }
                }) {
                    Text("ENTRAR")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.1, green: 0.4, blue: 0.7)) // Match blue color
                        .cornerRadius(25)
                }
                .padding(.top, 20)
                
                // Face ID Button
                Button(action: {
                    // TODO : Implement Face ID login action
                }) {
                    HStack {
                        Image(systemName: "faceid")
                            .font(.title2)
                        Text("Entrar com Face ID")
                            .font(.subheadline)
                    }
                    .foregroundColor(Color(red: 255/255, green: 220/255, blue: 193/255))
                }
                
                Spacer()
            }
            .padding(30)
            
        }.onAppear {
            Task { await viewModel.verifyStoredToken()}
        }.fullScreenCover(isPresented: $viewModel.isAuthenticated) {
            HomeView()
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
