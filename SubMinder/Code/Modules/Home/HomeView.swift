//
//  HomeView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var baseManager: BaseManager
    @StateObject var viewModel: HomeViewModel
    private let authService: AuthService
    
    @State var showAddModal: Bool = false
    
    init(authService: AuthService) {
        self.authService = authService
        self._viewModel = StateObject(wrappedValue: HomeViewModel(authService: authService))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                vwTopBar()
                    .frame(height: 40)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                
                ScrollView {
                    vwSummary()
                    vwSuscriptionsSection()
                        .padding(.top, 20)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                SMAddIconButton(action: {
                    showAddModal = true
                })
                .padding(.trailing, 25)
                .padding(.bottom, 25)
                .fullScreenCover(isPresented: $showAddModal, content: {
                    NewSubscriptionView(authService: authService)
                        .gesture(
                             DragGesture().onEnded { value in
                               if value.location.y - value.startLocation.y > 150 {
                                   withAnimation(.easeIn) {
                                       showAddModal.toggle()
                                   }
                                  
                               }
                             }
                        )
                })
            }
        }
    }
    
    @ViewBuilder private func vwTopBar() -> some View {
        HStack {
            VStack(alignment: .leading) {
                SMText(text: "Bienvenido 👋🏼", fontType: .regular, size: .mediumLarge)
                    .foregroundStyle(Color.secondary2)
                SMText(text: "Jonathan!", fontType: .medium, size: .mediumLarge)
            }
            
            Spacer()
            
            SMIconButton(image: "bell", action: {
                viewModel.signOut()
            })
        }
    }
    
    @ViewBuilder private func vwSummary() -> some View {
        SMScrollableTabView(info: [
            ScrollableInfo(text: "10€", description: "Gastos de esta semana"),
            ScrollableInfo(text: "20€", description: "Gastos de este mes"),
            ScrollableInfo(text: "30€", description: "Gastos totales")]
        )
        
        HStack(spacing: 14) {
            vwSummaryItem(value: "10", 
                          text: "Suscripciones",
                          gradient: LinearGradient(
                            colors: [Color.additionalGreen,
                                     Color.additionalGreen],
                            startPoint: .topLeading,
                            endPoint: .trailing),
                          action: {
                
            })
            
            vwSummaryItem(value: "2", 
                          text: "Pagos esta semana",
                          gradient: LinearGradient(
                            colors: [Color.additionalPurple,
                                     Color.additionalBlue],
                            startPoint: .topLeading,
                            endPoint: .trailing),
                          action: {
                
            })
            
            vwSummaryItem(value: "1", 
                          text: "Pruebas gratuitas",
                          gradient: LinearGradient(
                            colors: [Color.additionalPurple, Color.additionalPurple],
                            startPoint: .bottom,
                            endPoint: .trailing),
                          action: {
                
            })
        }
    }
    
    @ViewBuilder private func vwSuscriptionsSection() -> some View {
        
        let width: CGFloat = 180
        let columns = [GridItem(.fixed(width)),
                       GridItem(.fixed(width))]
        
        VStack(alignment: .leading) {
            SMText(text: "Suscripciones", fontType: .bold, size: .large)
                .foregroundStyle(Color.secondary2)
                .padding(.horizontal, 20)
            
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<50) { index in
                        vwSuscriptionGridItem(model: NewSubscriptionModel(id: 1, name: "Netflix", image: "netflix", price: 18.99, type: .quarterly, divisa: .eur))
                            .frame(width: width, height: width)
                    }
                }
        }
    }
    
    @ViewBuilder private func vwSuscriptionGridItem(model: NewSubscriptionModel) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                
                Rectangle()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(Color.secondary1.opacity(0.9))
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay {
                        Image(model.image)
                            .resizable()
                            .frame(width: 37, height: 37)
                            .shadow(radius: 5)
                    }
                    
                Spacer()
                
                VStack(alignment: .leading) {
                    SMText(text: "\(model.price) €")
                    SMText(text: "\(model.type.rawValue)", fontType: .medium, size: .smallLarge)
                        .foregroundStyle(Color.primary3)
                }
            }
            
            SMText(text: model.name, fontType: .bold, size: .mediumLarge)
                .foregroundStyle(Color.secondary2)
            
            HStack(spacing: 10) {
                SMCircularProgressBar(text: "3", progress: 0.6)
                    .frame(width: 28, height: 28)
                SMText(text: "Dias restantes", fontType: .medium, size: .smallLarge)
                    .foregroundStyle(Color.secondary2)
            }
        }
        .padding(.horizontal)
        .frame(width: 175, height: 175)
        .background(Color.primary6)
        .clipShape(.rect(cornerRadius: 30))
        .shadow(radius: 0.5)
    }
    
    @ViewBuilder private func vwSummaryItem(value: String, text: String, gradient: LinearGradient, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }, label: {
            VStack(alignment: .center, spacing: 3) {
                SMText(text: value, fontType: .bold, size: .header)
                SMText(text: text, fontType: .medium, size: .small)
                    .lineLimit(2)
                    .padding(.horizontal, 8)
                    .multilineTextAlignment(.center)
                    
            }
            .foregroundStyle(.white)
            .frame(width: 110, height: 110)
            .background(
                gradient
            )
            .clipShape(.rect(cornerRadius: 30))
            .shadow(radius: 5)
        })
    }
}

#Preview {
    HomeView(authService: AuthService())
        .environmentObject(BaseManager())
}
