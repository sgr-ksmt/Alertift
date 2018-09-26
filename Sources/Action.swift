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
        typealias Handler = (UIAlertAction) -> Void
        
        case `default`(String?)
        case destructive(String?)
        case cancel(String?)
        
        init(title: String?) {
            self = .default(title)
        }
        
        /// **UIAlertAction**'s title
        private var title: String? {
            switch self {
            case .default(let title): return title
            case .destructive(let title): return title
            case .cancel(let title): return title
            }
        }
        
        /// **UIAlertAction**'s style
        private var style: UIAlertAction.Style {
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
        func buildAlertAction(handler actionHandler: Action.Handler?) -> UIAlertAction {
            return UIAlertAction(title: title, style: style, handler: actionHandler)
        }
    }
}
