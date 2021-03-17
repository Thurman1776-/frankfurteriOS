//
//  Utils.swift
//  iOS-app
//
//  Created by Daniel Garcia on 17.03.21.
//

import SwiftUI

// MARK: - UIKit hacks

#if canImport(UIKit)
extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
        )
    }
}
#endif
