//
//  MainView.swift
//  iOS-app
//
//  Created by Daniel Garcia on 14.03.21.
//

import SwiftUI
import Redux

struct MainView: View {
    @EnvironmentObject
    private var store: ReduxStore
    var body: some View {
        VStack(spacing: 8) {
            Text("Frankfurter app")
            
            List(store.appState.currencyList.currencies, id: \.id) { currency in
                Text("Currency: \(currency.fullName)")
                Text("Currency code: \(currency.code)")
                    .padding()
            }
        }
    }
}

// MARK: - App State extensions

extension CurrencyList.Currency: Identifiable {
    public var id: Int { fullName.hash + code.hash }
}

