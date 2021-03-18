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
        NavigationView {
            VStack(spacing: 8) {
                NavigationLink(destination: CurrencyListView(store.appState.currencyList.currencies)) {
                    Text("See available currencies")
                        .foregroundColor(.blue)
                }
                NavigationLink(destination: CurrencyConverter().environmentObject(store)) {
                    Text("Currency converter")
                }
            }
            .navigationBarTitle("Frankfurter app")
        }
    }
}

// MARK: - Inner views

private struct CurrencyListView: View {
    
    private let currencies: [CurrencyList.Currency]
    @Environment(\.dispatcher)
    private var dispatcher
    
    init(_ currencies: [CurrencyList.Currency]) {
        self.currencies = currencies
    }
    
    var body: some View {
        if currencies.isEmpty == false {
            List(currencies, id: \.id) {
                Text("Currency: \($0.fullName) - \($0.code)")
            }
        } else {
            Button("Tap to download") { dispatcher.dispatch(CurrencyAction.getCurrencies) }
        }
    }
}
