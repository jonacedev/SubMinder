//
//  SplashView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var rootManager: RootManager
    
    var body: some View {
        Text("Splash")
    }
}

#Preview {
    SplashView()
        .environmentObject(RootManager())
}
