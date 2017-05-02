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
    final public class ActionSheet: AlertType, _AlertType {
        
        var _alertController: InnerAlertController!
        public var alertController: UIAlertController {
            return _alertController as UIAlertController
        }
        
        public static var backgroundColor: UIColor?
        public static var buttonTextColor: UIColor?
        public static var titleTextColor: UIColor?
        public static var messageTextColor: UIColor?

        /// Make action sheet
        ///
        /// - Parameters:
        ///   - title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
        ///   - message: Descriptive text that provides additional details about the reason for the alert.
        /// - Returns: Instance of **ActionSheet**
        public init(title: String? = nil, message: String? = nil) {
            buildAlertControlelr(title: title, message: message, style: .actionSheet)
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
        /// - Returns: Myself
        public func popover(sourceView view: UIView?, sourceRect rect: CGRect) -> Self {
            _alertController.popoverPresentationController?.sourceView = view
            _alertController.popoverPresentationController?.sourceRect = rect
            return self
        }

        /// Add barButtonItem to **popoverPresentationController**.
        ///
        /// If you want to use action sheet on iPad, you have to use this method.
        /// - Parameters:
        ///   - barButtonItem: UIBarButtonItem
        /// - Returns: Myself
        public func popover(barButtonItem: UIBarButtonItem?) -> Self {
            _alertController.popoverPresentationController?.barButtonItem = barButtonItem
            return self
        }
        
        deinit {
            Debug.log()
        }
    }
}
