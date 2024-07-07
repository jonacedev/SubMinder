//
//  WheelDatePickerView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 7/7/24.
//

import SwiftUI

struct WheelDatePickerView: View {
    
    let title: String
    @Binding var paymentDate: Date
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                SMText(text: title)
            }
            .padding()

            Divider()
            
            DatePicker("", selection: $paymentDate, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.wheel)
            
            SMMainButton(title: "Aceptar", action: {
                action()
            })
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
    }
}

#Preview {
    WheelDatePickerView(title: "Picker title", paymentDate: .constant(.now), action: { })
}
