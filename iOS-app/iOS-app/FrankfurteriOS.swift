//
//  FrankfurteriOS.swift
//
//  Created by Daniel Garcia on 14.03.21.
//

import SwiftUI
import Redux
import fudux

@main
struct FrankfurteriOS: App {
    @ObservedObject
    private var store = ReduxStore()
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(store)
                .onAppear(perform: {
                    store.startObserving()
                    ReduxAPI.dispatch(action: CurrencyAction.getCurrencies)
                })
                .onDisappear(perform: {
                    store.stopObserving()
                })
        }
    }
}

final class ReduxStore: ObservableObject {
    @Published
    private(set) var appState:  FrankfurterAppState
    private let reduxStore: ReduxAPI.Type = ReduxAPI.self
    private var unsubscribe: () -> Void = { }
    
    init(appState: FrankfurterAppState = .initialState) {
        self.appState = appState
        reduxStore.initiateStore()
    }
    
    func startObserving() {
        let storeObserver =  Observer<FrankfurterAppState> { [unowned self] newState in
            DispatchQueue.main.async {
                print("New state: \(newState)")
                appState = newState
            }
        }
        unsubscribe = reduxStore.subscribeObserver(storeObserver)
    }
    
    func stopObserving() {
        unsubscribe()
    }
}
