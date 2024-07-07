//
//  SMDropDownMenu.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 7/7/24.
//

import SwiftUI

struct SMDropDownMenu: View {
    
    let options: [String]
    @Binding var selectedOptionIndex: Int
    
    var menuWidth: CGFloat = 150
    var buttonHeight: CGFloat = 40
    var maxItemDisplayed: Int = 3
    @State var showDropdown: Bool = false
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        showDropdown.toggle()
                    }
                }, label: {
                    HStack(spacing: nil) {
                        SMText(text: options[selectedOptionIndex], fontType: .regular, size: .medium)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .tint(Color.secondary3)
                            .rotationEffect(.degrees(showDropdown ? -180 : 0))
                    }
                })
                .padding(.horizontal, 20)
                .frame(width: menuWidth, height: buttonHeight, alignment: .leading)
                
                // selection menu
                if showDropdown {
                    let scrollViewHeight: CGFloat = options.count > maxItemDisplayed ? (buttonHeight * CGFloat(maxItemDisplayed)) : (buttonHeight * CGFloat(options.count))
                    
                    ScrollViewReader { scrollViewProxy in
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(0..<options.count, id: \.self) { index in
                                    Button(action: {
                                        withAnimation {
                                            selectedOptionIndex = index
                                            showDropdown.toggle()
                                        }
                                    }, label: {
                                        HStack {
                                            SMText(text: options[index], fontType: .regular, size: .medium)
                                            Spacer()
                                            if index == selectedOptionIndex {
                                                Image(systemName: "checkmark")
                                                    .tint(Color.secondary4)
                                            }
                                        }
                                    })
                                    .padding(.horizontal, 20)
                                    .frame(width: menuWidth, height: buttonHeight, alignment: .leading)
                                    .id(index) // Add ID to each element
                                }
                            }
                        }
                        .frame(height: scrollViewHeight)
                        .onAppear {
                            // Scroll to the selected option when the view appears
                            DispatchQueue.main.async {
                                scrollViewProxy.scrollTo(selectedOptionIndex, anchor: .center)
                            }
                        }
                    }
                    .scrollDisabled(options.count <= maxItemDisplayed)
                }
            }
            .foregroundStyle(Color.secondary1)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.secondary4, lineWidth: 1)
                    )
            )
        }
        .frame(width: menuWidth, height: buttonHeight, alignment: .top)
    }
}
