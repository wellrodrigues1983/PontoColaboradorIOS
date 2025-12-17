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
    @State private var showRecover = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                HStack {
                    Text("Login")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal)

                Spacer(minLength: 20)

                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        if let msg = viewModel.emailValidationMessage {
                            Text(msg)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        ZStack(alignment: .trailing) {
                            Group {
                                if isSecured {
                                    SecureField("Senha", text: $viewModel.password)
                                } else {
                                    TextField("Senha", text: $viewModel.password)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                            Button(action: { isSecured.toggle() }) {
                                Image(systemName: isSecured ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 12)
                            }
                        }

                        if let msg = viewModel.passwordValidationMessage {
                            Text(msg)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }

                    Button(action: {
                        Task { await viewModel.login() }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .cornerRadius(8)
                        } else {
                            Text("Entrar")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.isFormValid ? Color.blue : Color.gray)
                                .cornerRadius(8)
                        }
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                .padding(.horizontal)
                
                Button(action: { showRecover = true }) {
                    Text("Esqueci a senha?")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showRecover) {
                    RecoverPasswordView()
                }

                Spacer()

                ZStack {
                    Color.blue.ignoresSafeArea(edges: .bottom)
                    HStack {
                        Text("Bem-vindo ao aplicativo")
                            .foregroundColor(.white)
                            .font(.footnote)
                            .padding()
                        Spacer()
                    }
                }
                .frame(height: 88)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
