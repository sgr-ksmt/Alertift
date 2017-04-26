//
//  Action.swift
//  Alertift
//
//  Created by Suguru Kishimoto on 4/27/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

extension Alertift {
    /// Action type for **Alert**, **ActionSheet**
    ///
    /// - `default`: Default action(action title)
    /// - destructive: Destructive action(action title)
    /// - cancel: Cancel description(action title)
    public enum Action {
        case `default`(String?)
        case destructive(String?)
        case cancel(String?)
        
        /// **UIAlertAction**'s title
        private var title: String? {
            switch self {
            case .default(let title): return title
            case .destructive(let title): return title
            case .cancel(let title): return title
            }
        }
        
        /// **UIAlertAction**'s style
        private var style: UIAlertActionStyle {
            switch self {
            case .default( _): return .default
            case .destructive( _): return .destructive
            case .cancel( _): return .cancel
            }
        }
        
        /// **Build UIAlertAction**
        ///
        /// - Parameter actionHandler: Action handler for **UIAlertAction**
        /// - Returns: Instance of **UIAlertAction**
        func buildAlertAction(handler actionHandler: @escaping (UIAlertAction) -> Void) -> UIAlertAction {
            return UIAlertAction(title: title, style: style, handler: { actionHandler($0) })
        }
    }
}
