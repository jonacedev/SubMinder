//
//  BaseAlert.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 9/7/24.
//

import SwiftUI

struct BaseAlert: View {

    struct Model: Equatable {
        static func == (lhs: BaseAlert.Model, rhs: BaseAlert.Model) -> Bool {
            return lhs.title == rhs.title && lhs.description == rhs.description
        }

        var image: String?
        var title = "", description = "", buttonText1 = "", buttonText2 = ""
        let action1: () -> Void
        var action2: (() -> Void)?
    }

    @State var fixedSize = true
    @State var maxHeight: CGFloat = 500
    @State var backOpacity: CGFloat = 0
    let model: Model

    var body: some View {
        ZStack {
            Color.black.opacity(backOpacity)
                .ignoresSafeArea()
                .blur(radius: 0)
            alert()
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation {
                backOpacity = 0.4
            }
        }
    }

    @ViewBuilder func alert() -> some View {
        VStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                    .clipShape(.rect(cornerRadius: 24))
                
                VStack(spacing: 12) {

                    if let image = model.image {
                        Image(image).resizable().frame(width: 36, height: 36, alignment: .center).foregroundStyle(.white)
                    }

                    alertTexts()
                        .padding(.top)
                        .padding(.horizontal)
                    buttons()

                }
                .padding()
            }
            .frame(maxHeight: maxHeight)
            .clipped()
            .fixedSize(horizontal: false, vertical: fixedSize)
        }
        .padding(.horizontal, 20)
    }

    @ViewBuilder func alertTexts() -> some View {
        SMText(text: model.title, fontType: .bold, size: .large)
            .foregroundStyle(Color.secondary1)
            .multilineTextAlignment(.center)
        SMText(text: model.description, fontType: .regular, size: .medium)
            .foregroundStyle(Color.secondary1)
            .multilineTextAlignment(.center)
    }

    @ViewBuilder func buttons() -> some View {
        VStack(spacing: 16) {
            SMMainButton(title: model.buttonText1, action: {
                withAnimation {
                    backOpacity = 0
                    model.action1()
                }
            })
            .frame(height: 45)
            
            if let action2 = model.action2 {
                SMMainButton(title: model.buttonText2, action: {
                    withAnimation {
                        backOpacity = 0
                        action2()
                    }
                })
                .frame(height: 45)
            }
                             
        }
        .padding(24)
    }
}

#Preview {
    BaseAlert(model: BaseAlert.Model(image: "ic_launch_logo", title: "Título", description: "No se pudieron obtener los datos de inicio.", buttonText1: "Botón 1", buttonText2: "Botón 2",
                                     action1: {},
                                     action2: nil))
}
