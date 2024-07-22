//
//  HomeView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

class AddModalState: ObservableObject {
    @Published var showFirstModal: Bool = false
    @Published var showSecondModal: Bool = false
}

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    @StateObject var modalState = AddModalState()
    @State var showTooltip = false
    
    @State private var showSelectedItemModal = false
    @State private var pushSettings = false
    
    @State private var pushAllSubs = false
    @State private var pushWeeklySubs = false
    @State private var pushFreeTrialsSubs = false
    @State private var selectedListType: ListType? = nil
    
    @State var needToUpdate = false
    
    private let firebaseManager: FirebaseManager
    
    init(firebaseManager: FirebaseManager) {
        self.firebaseManager = firebaseManager
        self._viewModel = StateObject(wrappedValue: HomeViewModel(firebaseManager: firebaseManager))
    }
    
    var body: some View {
        BaseView(content: content, viewModel: viewModel)
    }
    
    @ViewBuilder private func content() -> some View {
        GeometryReader { geo in
            NavigationStack {
                VStack {
                    vwTopBar()
                        .frame(height: 40)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    
                    ScrollView {
                        vwSummary()
                        vwSuscriptionsSection(geometry: geo)
                            .padding(.top, 20)
                    }
                    .refreshable {
                        viewModel.fetchHomeData()
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    vwOverlayAddButton()
                }
            }
            .tint(Color.secondary2)
        }
    }
    
    @ViewBuilder private func vwTopBar() -> some View {
        HStack {
            VStack(alignment: .leading) {
                SMText(text: "Bienvenido 👋🏼", fontType: .regular, size: .mediumLarge)
                    .foregroundStyle(Color.secondary2)
                SMText(text: viewModel.userData?.username ?? "", fontType: .medium, size: .mediumLarge)
            }
            
            Spacer()
            
            SMIconButton(image: "person", action: {
                pushSettings.toggle()
            })
        }
        .navigationDestination(isPresented: $pushSettings, destination: {
            SettingsView(firebaseManager: firebaseManager)
        })
    }
    
    @ViewBuilder private func vwSummary() -> some View {
        SMScrollableTabView(info: [
            ScrollableInfo(text: "\(viewModel.averageCost(period: .weekly))€", description: "Media semanal"),
            ScrollableInfo(text: "\(viewModel.averageCost(period: .monthly))€", description: "Media mensual"),
            ScrollableInfo(text: "\(viewModel.averageCost(period: .yearly))€", description: "Media anual")]
        )
        
        HStack(spacing: 14) {
           
            vwSummaryItem(value: viewModel.getTotalSubscriptions(),
                          text: "Suscripciones",
                          gradient: LinearGradient(
                            colors: [Color.additionalGreen,
                                     Color.additionalGreen],
                            startPoint: .topLeading,
                            endPoint: .trailing),
                          action: {
                pushAllSubs = true
            })
            .navigationDestination(isPresented: $pushAllSubs, destination: {
                SubscriptionListView(firebaseManager: firebaseManager, subscriptions: viewModel.subscriptions, listType: .all, needToUpdate: $needToUpdate)
                    .onDisappear {
                        checkNeedToUpdate()
                    }
            })
           
            vwSummaryItem(value: viewModel.getWeeklyPayments(),
                          text: "Pagos esta semana",
                          gradient: LinearGradient(
                            colors: [Color.additionalPurple,
                                     Color.additionalBlue],
                            startPoint: .topLeading,
                            endPoint: .trailing),
                          action: {
                pushWeeklySubs = true
            })
            .navigationDestination(isPresented: $pushWeeklySubs, destination: {
                SubscriptionListView(firebaseManager: firebaseManager, subscriptions: viewModel.subscriptions, listType: .weekly, needToUpdate: $needToUpdate)
                    .onDisappear {
                        checkNeedToUpdate()
                    }
            })
            
            vwSummaryItem(value: viewModel.getFreeTrials(),
                          text: "Pruebas gratuitas",
                          gradient: LinearGradient(
                            colors: [Color.additionalPurple, Color.additionalPurple],
                            startPoint: .bottom,
                            endPoint: .trailing),
                          action: {
                pushFreeTrialsSubs = true
            })
            .navigationDestination(isPresented: $pushFreeTrialsSubs, destination: {
                SubscriptionListView(firebaseManager: firebaseManager, subscriptions: viewModel.subscriptions, listType: .freeTrial, needToUpdate: $needToUpdate)
                    .onDisappear {
                        checkNeedToUpdate()
                    }
            })
        }
    }
    
    @ViewBuilder private func vwSuscriptionsSection(geometry: GeometryProxy) -> some View {
        
        let isIpad = DeviceInfo.isIpad() ? true : false
        let width = geometry.size.width / (isIpad ? 3 : 2) - 18
        let height = isIpad ? 200 : geometry.size.width / 2 - 18
        let columns = [GridItem(.fixed(width)),
                       GridItem(.fixed(width))]
        let columnsIpad = [GridItem(.fixed(width)),
                           GridItem(.fixed(width)),
                           GridItem(.fixed(width))]
        
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                SMText(text: "Proximos pagos", fontType: .bold, size: .large)
                    .foregroundStyle(Color.secondary2)
                    .padding(.leading, 20)
                
                Button(action: {
                    showTooltip.toggle()
                }, label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .tint(Color.secondary2)
                    
                })
                .smToolTip(isPresented: $showTooltip, background: {
                    Color.primary6
                }, foreground: {
                    SMText(text: "En los proximos 15 dias", fontType: .medium, size: .smallLarge)
                        .foregroundStyle(Color.sec2)
                        .padding()
                })
                .frame(width: 16)
                
                Spacer()
            }
            .zIndex(1)
            
            if viewModel.upcomingSubscriptions?.isEmpty == true {
                
                SMEmptyView(title: "No tienes pagos en los proximos 15 dias")
                    .padding(.horizontal, 20)
                
                SMLinkButtonStyled(title: "Ir a mis suscripciones", action: {
                    pushAllSubs = true
                })
                .padding(.top, 10)
                
            } else {
                LazyVGrid(columns: isIpad ? columnsIpad : columns, spacing: 10) {
                    ForEach(viewModel.upcomingSubscriptions ?? []) { subscription in
                        vwSuscriptionGridItem(model: subscription)
                            .frame(width: width, height: height)
                            .scrollTransition(.animated) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.8)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.8)
                            }
                            .onTapGesture {
                                viewModel.tapSubscription(subscription: subscription, success: {
                                    showSelectedItemModal = true
                                })
                            }
                            .sheet(isPresented: $showSelectedItemModal, onDismiss: {
                                checkNeedToUpdate()
                            }, content: {
                                if let selectedSubscription = viewModel.selectedSubscription {
                                    NavigationStack {
                                        SubscriptionDetailView(firebaseManager: firebaseManager, subscription: selectedSubscription, needToUpdate: $needToUpdate)
                                    }
                                }
                            })
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func vwSuscriptionGridItem(model: SubscriptionModelDto) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                
                Rectangle()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(model.getBackgroundColor())
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay {
                        Image(model.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 38, height: 38)
                            .shadow(radius: 0.3)
                    }
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading) {
                    SMText(text: "\(model.price)\(model.divisa.getCurrency())")
                    SMText(text: "\(model.type.rawValue)", fontType: .medium, size: .smallLarge)
                        .foregroundStyle(Color.primary3)
                }
                
                Spacer(minLength: 4)
            }
            
            SMText(text: model.name, fontType: .bold, size: .mediumLarge)
                .foregroundStyle(Color.secondary2)
                .lineLimit(1)
            
            HStack(spacing: 10) {
                SMCircularProgressBar(text: "\(model.paymentDate.toDate()?.getDaysIntervalFromNow() ?? 0)", progress: viewModel.calculateProgress(type: model.type, endDate: model.paymentDate.toDate() ?? .now))
                    .frame(width: 29, height: 29)
                SMText(text: "Dias restantes", fontType: .medium, size: .smallLarge)
                    .foregroundStyle(Color.secondary2)
            }
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
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
    
    @ViewBuilder private func vwOverlayAddButton() -> some View {
        SMAddIconButton(action: {
            modalState.showFirstModal = true
        })
        .padding(.trailing, 25)
        .padding(.bottom, 25)
        .fullScreenCover(isPresented: $modalState.showFirstModal, onDismiss: {
            viewModel.fetchHomeData()
        }, content: {
            NavigationStack {
                NewSubscriptionView(firebaseManager: firebaseManager)
                    .environmentObject(modalState)
            }
        })
    }
    
    func checkNeedToUpdate() {
        if needToUpdate {
            viewModel.fetchHomeData()
        }
        needToUpdate = false
    }
}

#Preview {
    HomeView(firebaseManager: FirebaseManager())
}
