//
//  ActionSheet.swift
//  Alertift
//
//  Created by Suguru Kishimoto on 4/27/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

extension Alertift {
    /// ActionSheet
    final public class ActionSheet: AlertBase {
        /// Make action sheet
        ///
        /// - Parameters:
        ///   - title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
        ///   - message: Descriptive text that provides additional details about the reason for the alert.
        /// - Returns: Instance of **ActionSheet**
        public init(title: String? = nil, message: String? = nil) {
            super.init(title: title, message: message, style: .actionSheet)
        }
        
        /// Add action to alertController
        public func action(_ action: Alertift.Action, handler: @escaping Alertift.ActionHandler = {}) -> Self {
            _alertController.addAction(buildAlertAction(action, handler: handler))
            return self
        }
        
        /// Add sourceView and sourceRect to **popoverPresentationController**.
        ///
        /// If you want to use action sheet on iPad, you have to use this method.
        /// - Parameters:
        ///   - view: sourceView
        ///   - rect: sourceRect
        /// - Returns: MySelf
        public func popover(sourceView view: UIView?, sourceRect rect: CGRect) -> Self {
            _alertController.popoverPresentationController?.sourceView = view
            _alertController.popoverPresentationController?.sourceRect = rect
            return self
        }
        
        deinit {
            Debug.log()
        }
    }
}
