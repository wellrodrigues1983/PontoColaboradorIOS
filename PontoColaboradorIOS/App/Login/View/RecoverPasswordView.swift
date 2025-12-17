//
//  RecoverPasswordView.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 16/12/25.
//

import SwiftUI

struct RecoverPasswordView: View {
    @StateObject private var viewModel = RecoverPasswordViewModel()
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Recuperar senha")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)

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
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: {
                    Task { await viewModel.sendRecovery() }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(8)
                    } else {
                        Text("Enviar instruções")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isEmailValid ? Color.blue : Color.gray)
                            .cornerRadius(8)
                    }
                }
                .disabled(!viewModel.isEmailValid || viewModel.isLoading)

                if let success = viewModel.successMessage {
                    Text(success)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }

                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: Button("Fechar") { presentationMode.wrappedValue.dismiss() })
        }
    }
}
