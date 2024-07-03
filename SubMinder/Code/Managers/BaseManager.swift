//
//  RootManager.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 2/7/24.
//

import Foundation

class BaseManager: ObservableObject {
    
    //@Published var alert: BaseAlert.Model?
    @Published private var loading: Bool = false
    
    func showLoading() {
        loading = true
    }
    
    func hideLoading() {
        loading = false
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
