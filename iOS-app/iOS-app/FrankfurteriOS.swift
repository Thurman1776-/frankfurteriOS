//
//  FrankfurteriOS.swift
//
//  Created by Daniel Garcia on 14.03.21.
//

import SwiftUI
import Redux

@main
struct FrankfurteriOS: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    ReduxAPI.initiateStore()
                    ReduxAPI.dispatch(action: CurrencyAction.getCurrencies)
                })
        }
    }
}
