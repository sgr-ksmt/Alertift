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

    var alertBackgroundColor: UIColor?
    var titleTextColor: UIColor? = .black
    var messageTextColor: UIColor? = .black
    var titleTextAlignment: NSTextAlignment = .center
    var messageTextAlignment: NSTextAlignment = .center
    
    
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
    
    /// Returns actionWithTextFieldsHandler
    var actionWithTextFieldsHandler: () -> ([UITextField]?) {
        return { [weak self] in
            self?.textFields
        }
    }
    
    /// Returns finallyExecutor
    var finallyExecutor: (UIAlertAction) -> Void {
        return { [weak self] action in
            self?.finallyHandler?(action, self?.actions.index(of: action) ?? -1)
        }
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        adaptBackgroundColor()
        updateTitleLabel()
        updateMessageLabel()
    }
    
    private func adaptBackgroundColor() {
        mainView?.backgroundColor = alertBackgroundColor
        if preferredStyle == .actionSheet {
            if let cancelTitle = actions.filter({ $0.style == .cancel }).first?.title {
                if let cancelButton = searchLabel(from: cancelTitle )?.superview?.superview {
                    cancelButton.backgroundColor = alertBackgroundColor
                }
            }
        }
    }
    
    var titleLabel: UILabel? {
        return title.flatMap(searchLabel(from:))
    }
    
    var messageLabel: UILabel? {
        return message.flatMap(searchLabel(from:))
    }

    private func updateTitleLabel() {
        if let titleLabel = titleLabel {
            titleLabel.textColor = titleTextColor
            titleLabel.textAlignment = titleTextAlignment
        }
    }

    private func updateMessageLabel() {
        if let messageLabel = messageLabel {
            messageLabel.textColor = messageTextColor
            messageLabel.textAlignment = messageTextAlignment
        }
    }
    
    private var mainView: UIView? {
        return view.subviews.first?.subviews.first?.subviews.first
    }
    
    private func searchLabel(from text: String) -> UILabel? {
        return view.recursiveSubviews
            .flatMap { $0 as? UILabel}
            .first { $0.text == text }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        Debug.log()
    }
}

extension UIView {
    
    var recursiveSubviews: [UIView] {
        return subviews.reduce(subviews, { return $0 + $1.recursiveSubviews })
    }
}
