//
//  LocationRequestView.swift
//  PontoColaboradorIOS
//
//  Created by Wellington Rodrigues on 18/02/26.
//

import SwiftUI

struct LocationRequestView: View {
    @Binding var isPresented: Bool

    var body: some View {
        ZStack{
            Color(.systemBlue).ignoresSafeArea()
            VStack{
                Spacer()

                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .padding(.bottom, 32)
                Text("Permissão de Localização")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                Text("Para registrar seu ponto, precisamos acessar sua localização. Por favor, permita o acesso para garantir que seu ponto seja registrado corretamente.")
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()

                VStack{
                    Button(action: {
                        isPresented = false
                        LocationManager.shared.requestLocation()
                        
                    }) {
                        Text("Permitir Acesso")
                            .font(.headline)
                            .foregroundColor(Color(.systemBlue))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding()

                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Negar Acesso")
                            .font(.headline)
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding()
                }
            }
        }
    }
}

#Preview {
    LocationRequestView(isPresented: .constant(true))
}
