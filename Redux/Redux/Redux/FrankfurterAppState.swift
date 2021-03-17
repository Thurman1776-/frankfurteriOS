//
//  FrankfurterAppState.swift
//  Redux
//
//  Created by Daniel Garcia on 14.03.21.
//

import fudux

// MARK: - Main State

public struct FrankfurterAppState: Equatable {
    public internal(set) var currencyList: CurrencyList
    public internal(set) var currencyConversion: CurrencyConversion
}

public extension FrankfurterAppState {
    static let initialState = Self(currencyList: .initialState, currencyConversion: .initialState)
}

// MARK: - Reducer

func appReducer(action: Action, state: inout FrankfurterAppState) {
    currencyReducer(action: action, state: &state.currencyList)
    currencyConversionReducer(action: action, state: &state.currencyConversion)
}

// MARK: - CurrencyList

public struct CurrencyList: Equatable {
    public let currencies: [Currency]
    public let errorMessage: String?
    
    public struct Currency: Equatable {
        public let fullName: String
        public let code: String
        
        public init(fullName: String, code: String) {
            self.fullName = fullName
            self.code = code
        }
    }
}

public enum CurrencyAction: Action {
    case setCurrencies([CurrencyList.Currency])
    case getCurrencies
    case setError(String)
}

func currencyReducer(action: Action, state: inout CurrencyList) {
    guard let action = action as? CurrencyAction else { return }
    
    switch action {
    case CurrencyAction.setCurrencies(let currencies):
        state = CurrencyList(currencies: currencies, errorMessage: state.errorMessage)
    case .getCurrencies: break
    case .setError(let message):
        state = CurrencyList(currencies: state.currencies, errorMessage: message)
    }
}

func downloadCurrenciesMiddleware(session: Networking) -> Middleware<FrankfurterAppState> {
    {
        getState, dispatchFunction in {
            next in {
                action in
                next(action)
                
                switch action {
                case CurrencyAction.getCurrencies:
                    session.getCurrencies { result in
                        switch result {
                        case .success(let value):
                            dispatchFunction(CurrencyAction.setCurrencies(value))
                        case .failure(let error):
                            dispatchFunction(CurrencyAction.setError(error.errorDescription))
                        }
                    }
                default:
                    break
                }
            }
        }
    }
}

extension CurrencyList {
    static let initialState = Self(currencies: [], errorMessage: nil)
}


// MARK: - Currency conversion

public struct CurrencyConversion: Equatable {
    public let sourceCurrency: String
    public let destinationCurrency: String
    public let originalAmount: Double
    public let result: Double?
    
}

struct ConversionResponse: Decodable {
    let amount: Double
    let base: String
    let date: String
    let rates: [String: Double]
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case base
        case date
        case rates
    }
}

public enum CurrencyConversionAction: Action {
    case performConversion(from: String, to: String, amount: Double)
    case setConversionResult(Double)
    case reset
}

func currencyConversionReducer(action: Action, state: inout CurrencyConversion) {
    guard let action = action as? CurrencyConversionAction else { return }
    
    switch action {
    case let .performConversion(from: sourceCurrency, to: destCurrency, amount: amount):
        state = .init(sourceCurrency: sourceCurrency, destinationCurrency: destCurrency, originalAmount: amount, result: nil)
    case .setConversionResult(let result):
        state = .init(
            sourceCurrency: state.sourceCurrency,
            destinationCurrency: state.destinationCurrency,
            originalAmount: state.originalAmount,
            result: result
        )
    case .reset:
        state = .initialState
    }
}

func performConversionMiddleware(session: Networking) -> Middleware<FrankfurterAppState> {
    {
        getState, dispatchFunction in {
            next in {
                action in
                next(action)
                
                switch action {
                case let CurrencyConversionAction.performConversion(from: sourceCurrency, to: destCurrency, amount: amount):
                    session.performConversion(from: sourceCurrency, to: destCurrency, with: amount) { result in
                        switch result {
                        case .success(let value):
                            dispatchFunction(CurrencyConversionAction.setConversionResult(value))
                        case .failure:
                            // TODO - ran out of time 😬
                        break
                        }
                    }
                default:
                    break
                }
            }
        }
    }
}

extension CurrencyConversion {
    static let initialState = CurrencyConversion(
        sourceCurrency: "EUR",
        destinationCurrency: "EUR",
        originalAmount: 0,
        result: nil
    )
}
