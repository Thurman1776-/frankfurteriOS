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
}

public extension FrankfurterAppState {
    static let initialState = Self(currencyList: .initialState)
}

// MARK: - Reducer

func appReducer(action: Action, state: inout FrankfurterAppState) {
    currencyReducer(action: action, state: &state.currencyList)
}

// MARK: - CurrencyList

public struct CurrencyList: Equatable {
    public let currencies: [Currency]
    public let errorMessage: String?
    
    public struct Currency: Equatable {
        public let fullName: String
        public let code: String
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
