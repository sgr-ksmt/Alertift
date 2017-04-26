//
//  InnerAlertController.swift
//  Alertift
//
//  Created by Suguru Kishimoto on 4/27/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit

/// InnerAlertController
/// subclass of **UIAlertController**
class InnerAlertController: UIAlertController {
    /// textFieldTextDidChangeHandler: ((UITextField, Int) -> Void)
    var textFieldTextDidChangeHandler: _Alert.TextFieldHandler?
    
    /// finallyHandler: (UIAlertAction, Int) -> Void
    var finallyHandler: Alertift.FinallyHandler?

    /// Register UITextFieldTextDidChange notification
    ///
    /// - Parameter textField: textField
    func registerTextFieldObserver(_ textField: UITextField) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.textFieldDidChange(_:)),
            name: .UITextFieldTextDidChange, object: textField
        )
    }
    
    /// Delegate method for UITextFieldTextDidChange
    ///
    /// - Parameter notification: notification (object is UITextField)
    @objc private func textFieldDidChange(_ notification: Notification) {
        guard let textField = notification.object as? UITextField else {
            return
        }
        
        guard let index = textFields?.index(of: textField) else {
            return
        }
        textFieldTextDidChangeHandler?(textField, index)
    }
    
    /// Combine originalHandler and finallyHandler with textFields.
    ///
    /// - Parameter originalHandler: original action handler.
    /// - Returns: New action handler.
    func combineActionWithTextFieldsHandler(_ originalHandler: @escaping _Alert.ActionWithTextFieldsHandler) -> (UIAlertAction) -> Void {
        return combineActionHandler { [weak self] in
            originalHandler(self?.textFields)
        }
    }
    
    /// Combine originalHandler and finallyHandler.
    ///
    /// - Parameter originalHandler: original action handler.
    /// - Returns: New action handler.
    func combineActionHandler(_ originalHandler: @escaping () -> Void) -> (UIAlertAction) -> Void {
        return { [weak self] action in
            guard let strongSelf = self else {
                return
            }
            originalHandler()
            strongSelf.finallyHandler?(action, strongSelf.actions.index(of: action) ?? -1)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
