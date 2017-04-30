//
//  Alert.swift
//  Alertift
//
//  Created by Suguru Kishimoto on 4/26/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

extension Alertift {
    /// Alert
    final public class Alert: AlertType, _AlertType {
        /// TextFieldHandler
        public typealias TextFieldHandler = ((UITextField, Int) -> Void)
        
        /// ActionWithTextFieldsHandler
        public typealias ActionWithTextFieldsHandler = ([UITextField]?) -> Void
        
        var _alertController: InnerAlertController!
        public var alertController: UIAlertController {
            return _alertController as UIAlertController
        }

        public static var backgroundColor: UIColor?
        public static var buttonTextColor: UIColor?
        public static var titleTextColor: UIColor?
        public static var messageTextColor: UIColor?

        /// Make alert
        ///
        /// - Parameters:
        ///   - title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
        ///   - message: Descriptive text that provides additional details about the reason for the alert.
        /// - Returns: Instance of **Alert**
        public init(title: String? = nil, message: String? = nil) {
            buildAlertControlelr(title: title, message: message, style: .alert)
        }
        
        /// Add alertAction to alertController
        ///
        /// - Parameters:
        ///   - alertAction: UIAlertAction
        ///   - isPreferred: If isPreferred is true, alertAction becomes preferredAction.
        private func addActionToAlertController(_ alertAction: UIAlertAction, isPreferred: Bool) {
            _alertController.addAction(alertAction)
            if isPreferred {
                _alertController.preferredAction = alertAction
            }
        }
        
        /// Add action to Alert
        ///
        /// - Parameters:
        ///   - action: Alert action.
        ///   - isPreferred: If you want to change this action to preferredAction, set true. Default is false.
        ///   - handler: The block to execute after this action performed.
        /// - Returns: Myself
        public func action(_ action: Alertift.Action, isPreferred: Bool = false, handler: @escaping Alertift.ActionHandler = {}) -> Self {
            addActionToAlertController(buildAlertAction(action, handler: handler), isPreferred: isPreferred)
            return self
        }

        /// Add action to Alert
        ///
        /// - Parameters:
        ///   - action: Alert action.
        ///   - isPreferred: If you want to change this action to preferredAction, set true. Default is false.
        ///   - textFieldsHandler: The block that returns array of UITextFields to execute after this action performed.
        /// - Returns: Myself
        final public func action(_ action: Alertift.Action, isPreferred: Bool = false, textFieldsHandler handler: @escaping ActionWithTextFieldsHandler) -> Self {
            addActionToAlertController(
                buildAlertAction(action, handler: merge(_alertController.actionWithTextFieldsHandler, handler)),
                isPreferred: isPreferred
            )
            return self
        }

        /// Add text field to alertController
        ///
        /// - Parameter handler: Define handler if you want to customize UITextField. Default is nil.
        /// - Returns: Myself
        public func textField(configurationHandler handler: ((UITextField) -> Void)? = nil) -> Self {
            _alertController.addTextField { [weak self] textField in
                guard let strongSelf = self else {
                    return
                }
                handler?(textField)
                strongSelf._alertController.registerTextFieldObserver(textField)
            }
            
            return self
        }
        
        /// Add textFieldHandler to alertController.
        ///
        /// If text field's text is changed, execute textFieldHandler with text field and index.
        ///
        /// - Parameter textFieldTextDidChangeHandler: TextFieldHandler (UITextField, Int) -> Void
        /// - Returns: Myself
        public func handleTextFieldTextDidChange(textFieldTextDidChangeHandler: TextFieldHandler?) -> Self {
            _alertController.textFieldTextDidChangeHandler = textFieldTextDidChangeHandler
            return self
        }
        
        deinit {
            Debug.log()
        }
    }
}
