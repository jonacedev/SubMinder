//
//  BaseViewModel.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 9/7/24.
//

import Combine
import UIKit

class BaseViewModel: ObservableObject {

    // MARK: - Properties

    @Published var alert: BaseAlert.Model?
    @Published var loading: Bool?

    func showLoading() {
        DispatchQueue.main.async {
            self.loading = true
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.loading = false
        }
    }
    
    func manageError(alert: BaseAlert.Model) {
        hideLoading()
        DispatchQueue.main.async {
            self.alert = alert
        }
    }
    
    func hideAlert() {
        self.alert = nil
    }
}
