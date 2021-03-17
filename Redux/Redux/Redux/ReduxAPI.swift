//
//  ReduxAPI.swift
//  Redux
//
//  Created by Daniel Garcia on 14.03.21.
//

import fudux

public struct ReduxAPI {
    private static var dispatchFunction: DispatchFunction!
    private static var subscribe: Subscribe<FrankfurterAppState>!
    private static var getState: GetState<FrankfurterAppState>!
    
    public static func initiateStore() {
        let appliedMiddlewares = applyMiddleware(
            middlewares: [
                downloadCurrenciesMiddleware(session: Networking()),
                performConversionMiddleware(session: Networking())
            ]
        )
        let composedStore = appliedMiddlewares(createStore)
        let (dispatch, subscribe, getState) = composedStore(appReducer, FrankfurterAppState(currencyList: .initialState, currencyConversion: .initialState))
        
        dispatchFunction = dispatch
        Self.subscribe = subscribe
        Self.getState = getState
    }
    
    public static func subscribeObserver(_ observer: Observer<FrankfurterAppState>) -> () -> Void {
        guard subscribe != nil else {
            fatalError("You first have to configure the Redux store! Try calling `initiateStore` first")
        }
        
        return subscribe(observer)
    }
    
    public static func currentState() -> GetState<FrankfurterAppState> {
        guard getState != nil else {
            fatalError("You first have to configure the Redux store! Try calling `initiateStore` first")
        }
        
        return getState
    }
    
    public static func dispatch(action: Action) {
        guard dispatchFunction != nil else {
            fatalError("You first have to configure the Redux store! Try calling `initiateStore` first")
        }
        
        dispatchFunction(action)
    }
}
