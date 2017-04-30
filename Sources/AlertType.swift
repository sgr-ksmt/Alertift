//
//  AlertType.swift
//  Alertift
//
//  Created by Suguru Kishimoto on 4/30/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation


internal protocol _AlertType: class {
    var alertController: InnerAlertController! { get set }
}

extension _AlertType where Self: AlertType {
    func buildAlertControlelr(title: String? = nil, message: String? = nil, style: UIAlertControllerStyle) {
        alertController = InnerAlertController(title: title, message: message, preferredStyle: style)
        alertController.alertBackgroundColor = type(of: self).backgroundColor
        alertController.view.tintColor = type(of: self).buttonTextColor
        alertController.titleTextColor = type(of: self).titleTextColor
        alertController.messageTextColor = type(of: self).messageTextColor
    }
}

public protocol AlertType: class {
    var alertController: InnerAlertController! { get }
    static var backgroundColor: UIColor? { get set }
    static var buttonTextColor: UIColor? { get set }
    static var titleTextColor: UIColor? { get set }
    static var messageTextColor: UIColor? { get set }
}

extension AlertType {    
    /// Build **UIAlertAction** using **Alertift.Action** and handler.
    ///
    /// - Parameters:
    ///   - action: action
    ///   - handler: The handler to execute after the action selected.
    /// - Returns: **UIAlertAction**
    func buildAlertAction(_ action: Alertift.Action, handler: @escaping Alertift.ActionHandler) -> UIAlertAction {
        return action.buildAlertAction(handler: ActionHandlerBuilder.build(handler, alertController.finallyExecutor))
    }
    
    /// Add finally handler.
    ///
    /// - Parameter handler: The handler to execute after either alert selected.
    /// - Returns: Myself
    public func finally(handler: @escaping Alertift.FinallyHandler) -> Self {
        alertController.finallyHandler = handler
        return self
    }
    
    public func backgroundColor(_ color: UIColor?) -> Self {
        alertController.alertBackgroundColor = color
        return self
    }
    
    public func buttonColor(_ color: UIColor?) -> Self {
        alertController.view.tintColor = color
        return self
    }
    
    public func titleTextColor(_ color: UIColor?) -> Self {
        alertController.titleTextColor = color
        return self
    }
    
    public func messageTextColor(_ color: UIColor?) -> Self {
        alertController.messageTextColor = color
        return self
    }
    
    /// Show alert (or action sheet).
    ///
    /// - Parameters:
    ///   - viewController: The view controller to display over the current view controller’s content. Default is **UIApplication.shared.keyWindow?.rootViewController**
    ///   - completion: The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
    final public func show(on viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController, completion: (() -> Void)? = nil) {
        viewController?.present(alertController, animated: true, completion: completion)
    }
}
