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

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @AppStorage("isAuthenticated") private var isAuthenticated: Bool = false
    

    var body: some View {
        NavigationView {
            ZStack {
                Color(.appPrimary).ignoresSafeArea()
                VStack {
                    VStack {
                        Spacer()
                        Text("Login")
                            .font(.largeTitle)
                            .foregroundColor(.textPrimary)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    .padding()

                    Spacer()

                    VStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)

                            if !viewModel.email.elementsEqual("") {
                                if let msg = viewModel.emailValidationMessage {
                                    Text(msg)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
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
                            if !viewModel.password.elementsEqual("") {
                                if let msg = viewModel.passwordValidationMessage {
                                    Text(msg)
                                        .foregroundColor(.red)
                                        .font(.caption)
                                }
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
                    .padding(.horizontal, 24)
                    .padding(.bottom, 240)
                    .padding(.top, 16)
                    .background(Color.secondary)
                    .border(Color.gray.opacity(0.3), width: 1).contrast(0.8).cornerRadius(16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .ignoresSafeArea()
            }
        }
        .onAppear {
            Task { await viewModel.verifyStoredToken() }
        }
        // apresenta HomeView quando isAuthenticated == true
        .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
            HomeView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

