//
//  RootManager.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import Foundation

enum RootView {
    case splash
    case login
    case home
}

class RootManager: ObservableObject {
    
    @Published private var currentRoot: RootView = .splash
    //@Published var alert: BaseAlert.Model?
    @Published private var loading: Bool = false
    
    func changeRootTo(_ root: RootView) {
        currentRoot = root
    }
    
    func showLoading() {
        loading = true
    }
    
    func hideLoading() {
        loading = false
    }
    
    func getCurrentRoot() -> RootView {
        currentRoot
    }
    
    func isLoading() -> Bool {
        loading
    }
    
//    func showAlert(alert: BaseAlert.Model) {
//        self.alert = alert
//    }
//    
//    func hideAlert() {
//        self.alert = nil
//    }
}
