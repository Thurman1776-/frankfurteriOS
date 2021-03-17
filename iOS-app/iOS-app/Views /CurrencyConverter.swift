//
//  CurrencyConverter.swift
//  iOS-app
//
//  Created by Daniel Garcia on 17.03.21.
//

import SwiftUI
import Redux

struct CurrencyConverter: View {
    @EnvironmentObject
    private var store: ReduxStore
    @Environment(\.dispatcher)
    private var dispatcher
    
    var body: some View {
        if store.appState.currencyList.currencies.isEmpty {
            Text("Download currencies first")
        } else {
            VStack(spacing: 24) {
                CurrencyInput(title: "Source")
                CurrencyInput(title: "Destination")
            }
        }
    }
}

// MARK: Private views

private struct CurrencyInput: View {
    @State
    private var amount: String = ""
    @EnvironmentObject
    private var store: ReduxStore
    private let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        VStack {
            Text("\(title):")
            TextField(
                "Enter amount",  text: $amount, onCommit: { dismissKeyboard() }
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numbersAndPunctuation)
            PickerView(currencies: store.appState.currencyList.currencies)
        }
    }
}

private struct PickerView: View {
    @State
    private var selectedCurrency: CurrencyList.Currency = .baseCurrency
    @State
    private var shouldShowPicker = false
    private var currencies: [CurrencyList.Currency] = []
    
    init(currencies: [CurrencyList.Currency]) {
        self.currencies = currencies
        self.selectedCurrency = self.currencies.first ?? .baseCurrency
    }

    var body: some View {
        VStack {
            Button("\(selectedCurrency.code)", action: { shouldShowPicker.toggle() })
            if shouldShowPicker {
                Picker("Currency", selection: $selectedCurrency) {
                    ForEach(currencies, id: \.self) {
                        Text($0.code)
                    }
                }
            }
        }
    }
}
