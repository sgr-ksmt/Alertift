//
//  ActionHandlerBuilder.swift
//  Alertift
//
//  Created by Suguru Kishimoto on 4/28/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

final class ActionHandlerBuilder {
    private init() {}
    
    /// Build closure using two closure.
    static func build<T: UIAlertAction>(_ h1: @escaping () -> Void, _ h2: @escaping (T) -> Void) -> (T) -> Void {
        return { action in
            h1()
            h2(action)
        }
    }
}

/// merge two closure to one closure.
func merge<A, B, C>(_ h1: @escaping (A) -> B, _ h2: @escaping (B) -> C) -> (A) -> C {
    return { x in h2(h1(x)) }
}
