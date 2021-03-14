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
                    DispatcherKey.defaultValue = store
                })
                .onDisappear(perform: {
                    store.stopObserving()
                })
        }
    }
}

// MARK: - Redux store lifecycle

final class ReduxStore: ObservableObject, Dispatching {
    @Published
    private(set) var appState:  FrankfurterAppState
    private let reduxStore: ReduxAPI.Type
    private var unsubscribe: () -> Void = { }
    
    init(appState: FrankfurterAppState = .initialState, reduxStore: ReduxAPI.Type = ReduxAPI.self) {
        self.appState = appState
        self.reduxStore = reduxStore
        reduxStore.initiateStore()
    }
    
    func startObserving() {
        let storeObserver =  Observer<FrankfurterAppState> { [unowned self] newState in
            DispatchQueue.main.async {
                if newState != appState {
                    appState = newState
                }
            }
        }
        unsubscribe = reduxStore.subscribeObserver(storeObserver)
    }
    
    func stopObserving() { unsubscribe() }
    
    func dispatch(_ action: Action) { reduxStore.dispatch(action: action) }
}
