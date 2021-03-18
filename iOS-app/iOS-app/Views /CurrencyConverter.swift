//
//  CurrencyConverter.swift
//  iOS-app
//
//  Created by Daniel Garcia on 17.03.21.
//

import SwiftUI
import Combine
import Redux

struct CurrencyConverter: View {
    @EnvironmentObject
    private var store: ReduxStore
    @Environment(\.dispatcher)
    private var dispatcher
    
    @State
    private var sourceAmount: String = "0"
    @State
    private var destAmount: String = "0"
    
    @State
    private var sourceCurrency: String = CurrencyList.Currency.baseCurrency.code
    @State
    private var destCurrency: String = CurrencyList.Currency.baseCurrency.code
    
    var body: some View {
        if store.appState.currencyList.currencies.isEmpty {
            Text("Download currencies first")
        } else {
            VStack(spacing: 24) {
                CurrencyInputView(title: "Source", initialAmount: $sourceAmount, initialCurrency: $sourceCurrency)
                Divider()
                    .background(Color.black)
                Text("Convert to:")
                PickerView(currencies: store.appState.currencyList.currencies, currencyCode: $destCurrency)
                Button("Profit!") {
                    dispatcher.dispatch(
                        CurrencyConversionAction.performConversion(from: sourceCurrency, to: destCurrency, amount: Double(sourceAmount)!)
                    )
                }
                if store.appState.currencyConversion.result != nil {
                    Text("Result: \(store.appState.currencyConversion.result!)")
                    Button("Start over:") { dispatcher.dispatch(CurrencyConversionAction.reset) }
                }                
            }
        }
    }
}

// MARK: Private views

private struct CurrencyInputView: View {
    @Binding
    private var amount: String
    @Binding
    private var currency: String
    @EnvironmentObject
    private var store: ReduxStore
    private let title: String
    
    init(
        title: String,
        initialAmount: Binding<String>,
        initialCurrency: Binding<String>
    ) {
        self.title = title
        self._amount = initialAmount
        self._currency = initialCurrency
    }
    
    var body: some View {
        VStack {
            Text("\(title):")
            TextField(
                "Enter amount",  text: $amount, onCommit: { dismissKeyboard() }
            )
            .onReceive(Just(amount), perform: formatString(_:))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numbersAndPunctuation)
            PickerView(currencies: store.appState.currencyList.currencies, currencyCode: $currency)
        }
    }
    
    private func formatString(_ value: String) {
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        formater.locale = Locale(identifier: "de_DE")
        
        if let number = formater.number(from: value) {
            amount = number.stringValue
        }
    }
}

private struct PickerView: View {
    @Binding
    private var selectedCurrencyCode: String
    @State
    private var shouldShowPicker = false
    private var currencies: [String] = []
    
    init(currencies: [CurrencyList.Currency], currencyCode: Binding<String>) {
        self.currencies = currencies.map { $0.code }
        self._selectedCurrencyCode = currencyCode
    }

    var body: some View {
        VStack {
            Button("\(selectedCurrencyCode)", action: { shouldShowPicker.toggle() })
            if shouldShowPicker {
                Picker("Currency", selection: $selectedCurrencyCode) {
                    ForEach(currencies, id: \.self) {
                        Text($0)
                    }
                }
            }
        }
    }
}
