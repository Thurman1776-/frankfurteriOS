//
//  Enviroment+Extensions.swift
//  iOS-app
//
//  Created by Daniel Garcia on 14.03.21.
//

import fudux
import SwiftUI

public protocol Dispatching {
    func dispatch(_ action: Action)
}

struct DumbDispatcher: Dispatching {
    func dispatch(_: Action) {
        fatalError("Override this from with an actual dispatcher!")
    }
}

// MARK: - SwiftUI Environment plumbing

public struct DispatcherKey: EnvironmentKey {
    public static var defaultValue: Dispatching = DumbDispatcher()
}

public extension EnvironmentValues {
    var dispatcher: Dispatching {
        get { self[DispatcherKey.self] }
        set { self[DispatcherKey.self] = newValue }
    }
}
