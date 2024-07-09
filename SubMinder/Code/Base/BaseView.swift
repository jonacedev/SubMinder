//
//  BaseView.swift
//  SubMinder
//
//  Created by Jonathan Miguel Onrubia Solis on 9/7/24.
//

import SwiftUI

struct BaseView<Content: View>: View {

    let content: () -> Content
    @StateObject var viewModel: BaseViewModel

    var body: some View {
        ZStack {
            content()
            alert()
            loader()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }

    @ViewBuilder func alert() -> some View {
        if let alert = viewModel.alert {
            BaseAlert(model: alert)
        }
    }

    @ViewBuilder func loader() -> some View {
        if viewModel.loading == true {
            BaseLoader()
        }
    }
}
