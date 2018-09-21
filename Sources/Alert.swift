//
//  Alert.swift
//  Alertift
//
//  Created by Suguru Kishimoto on 4/26/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

extension Alertift {
    public enum AlertImagePosition {
        case top // Above title and message
        case center // Between title and message
        case bottom // Below title and message
    }
    
    /// Alert
    final public class Alert: AlertType, _AlertType {
        public typealias Handler = (UIAlertAction, Int, [UITextField]?) -> Void

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
        
        public func action(_ action: Alertift.Action, handler: Handler? = nil) -> Self {
            return self.action(action, isPreferred: false, handler: handler)
        }

        /// Add action to Alert
        ///
        /// - Parameters:
        ///   - action: Alert action.
        ///   - isPreferred: If you want to change this action to preferredAction, set true. Default is false.
        ///   - handler: The block to execute after this action performed.
        /// - Returns: Myself
        public func action(_ action: Alertift.Action, isPreferred: Bool, handler: Handler? = nil) -> Self {
            return self.action(action, image: nil, isPreferred: isPreferred, handler: handler)
        }

        /// Add action to Alert
        ///
        /// - Parameters:
        ///   - action: Alert action.
        ///   - image: Image of action.
        ///   - renderMode: Render mode for alert action image. Default is `.automatic`
        ///   - handler: The block to execute after this action performed.
        /// - Returns: Myself
        public func action(_ action: Alertift.Action, image: UIImage?, renderingMode: UIImage.RenderingMode = .automatic, handler: Handler? = nil) -> Self {
            return self.action(action, image: image, renderingMode: renderingMode, isPreferred: false, handler: handler)
        }

        /// Add action to Alert
        ///
        /// - Parameters:
        ///   - action: Alert action.
        ///   - image: Image of action
        ///   - renderMode: Render mode for alert action image. Default is `.automatic`
        ///   - isPreferred: If you want to change this action to preferredAction, set true. Default is false.
        ///   - handler: The block to execute after this action performed.
        /// - Returns: Myself
        public func action(_ action: Alertift.Action, image: UIImage?, renderingMode: UIImage.RenderingMode = .automatic, isPreferred: Bool, handler: Handler? = nil) -> Self {
            let alertAction = buildAlertAction(
                action,
                handler: merge(_alertController.actionWithTextFieldsHandler, handler ?? { (_, _, _)in })
            )

            if let image = image {
                alertAction.setValue(image.withRenderingMode(renderingMode), forKey: "image")
            }

            addActionToAlertController(alertAction, isPreferred: isPreferred)
            return self
        }

        /// Add text field to alertController
        ///
        /// - Parameter handler: Define handler if you want to customize UITextField. Default is nil.
        /// - Returns: Myself
        public func textField(configurationHandler handler: ((UITextField) -> Void)? = nil) -> Self {
            _alertController.addTextField { [weak self] textField in
                handler?(textField)
                self?._alertController.registerTextFieldObserver(textField)
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
        
        func convertFinallyHandler(_ handler: Any) -> InnerAlertController.FinallyHandler {
            return { (handler as? Handler)?($0, $1, $2) }
        }

        public func image(_ image: UIImage?, imageTopMargin: Alertift.ImageTopMargin = .none) -> Self {
            _alertController.setImage(image, imageTopMargin: imageTopMargin)
            return self
        }
        
        deinit {
            Debug.log()
        }
    }
}
