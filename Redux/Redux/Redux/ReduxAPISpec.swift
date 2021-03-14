//
//  ReduxAPISpec.swift
//  ReduxTests
//
//  Created by Daniel Garcia on 14.03.21.
//

import XCTest
@testable import Redux
import fudux

final class ReduxAPISpec: XCTestCase {

    func test_redux_store_is_properly_initialized() {
        ReduxAPI.initiateStore()
        
        let getState = ReduxAPI.currentState()
        XCTAssertNotNil(getState())
        
        var appState:  FrankfurterAppState?
        let observer = Observer<FrankfurterAppState> { appState = $0  }
        _ = ReduxAPI.subscribeObserver(observer)
        ReduxAPI.dispatch(action: CurrencyAction.setCurrencies([]))
        XCTAssertNotNil(appState)
    }
}
