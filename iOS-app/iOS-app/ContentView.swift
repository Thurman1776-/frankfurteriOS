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
            }
            .navigationBarTitle("Frankfurter app")
        }
    }
}

private struct CurrencyListView: View {
    private let currencies: [CurrencyList.Currency]
    
    init(_ currencies: [CurrencyList.Currency]) {
        self.currencies = currencies
    }
    
    var body: some View {
        List(currencies, id: \.id) { currency in
            Text("Currency: \(currency.fullName) - \(currency.code)")
        }
    }
}

// MARK: - App State extensions

extension CurrencyList.Currency: Identifiable {
    public var id: Int { fullName.hash + code.hash }
}

