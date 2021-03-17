//
//  AppState+Extensions.swift
//  iOS-app
//
//  Created by Daniel Garcia on 17.03.21.
//

import SwiftUI
import Redux

// MARK: - App State extensions

extension CurrencyList.Currency: Identifiable {
    public var id: Int { fullName.hash + code.hash }
}

extension CurrencyList.Currency: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(fullName.hash)
        hasher.combine(code.hash)
    }
}

extension CurrencyList.Currency {
    static let baseCurrency = CurrencyList.Currency(fullName: "Euro", code: "EUR")
}
