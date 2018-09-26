//
//  AlertType.swift
//  Alertift
//
//  Created by Suguru Kishimoto on 4/30/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

/// Internal AlertType protocol
internal protocol _AlertType: class {
    /// inner alertController
    var _alertController: InnerAlertController! { get set }
    func convertFinallyHandler(_ handler: Any) -> InnerAlertController.FinallyHandler
}

extension _AlertType where Self: AlertType {
    /// build AlertController
    func buildAlertControlelr(title: String? = nil, message: String? = nil, style: UIAlertController.Style) {
        _alertController = InnerAlertController(title: title, message: message, preferredStyle: style)
        _alertController.alertBackgroundColor = type(of: self).backgroundColor
        _alertController.view.tintColor = type(of: self).buttonTextColor
        _alertController.titleTextColor = type(of: self).titleTextColor
        _alertController.messageTextColor = type(of: self).messageTextColor
    }
}

/// AlertType protocol
public protocol AlertType: class {
    associatedtype Handler

    /// Add action to Alert
    ///
    /// - Parameters:
    ///   - action: Alert action.
    ///   - handler: The block to execute after this action performed.
    /// - Returns: Myself
    func action(_ action: Alertift.Action, handler: Handler?) -> Self
    
    /// UIAlertController
    var alertController: UIAlertController { get }
    /// default background color of Alert(ActionSheet).
    static var backgroundColor: UIColor? { get set }
    
    /// default button text color of Alert(ActionSheet).
    static var buttonTextColor: UIColor? { get set }
    
    /// default title text color of Alert(ActionSheet).
    static var titleTextColor: UIColor? { get set }
    
    /// default message text color of Alert(ActionSheet).
    static var messageTextColor: UIColor? { get set }
}

extension AlertType {
    private var _inner: _AlertType {
        return self as! _AlertType
    }
    
    /// Add actions to Alert
    ///
    /// - Parameters:
    ///   - actions: Alert actions.
    ///   - handler: The block to execute after this action performed.
    /// - Returns: Myself
    public func actions(_ actions: [Alertift.Action], handler: Handler? = nil) -> Self {
        actions.forEach { _ = action($0, handler: handler) }
        return self
    }
    
    public func actions(_ actions: [String?], handler: Handler? = nil) -> Self {
        return self.actions(actions.map(Alertift.Action.init(title:)), handler: handler)
    }
    
    /// Add finally handler.
    ///
    /// - Parameter handler: The handler to execute after either alert selected.
    /// - Returns: Myself
    public func finally(_ handler: Handler) -> Self {
        _inner._alertController.finallyHandler = _inner.convertFinallyHandler(handler)
        return self
    }
    
    

    
    /// Change background color
    ///
    /// - Parameter color: UIColor
    /// - Returns: Myself
    public func backgroundColor(_ color: UIColor?) -> Self {
        _inner._alertController.alertBackgroundColor = color
        return self
    }
    
    /// Change button text color
    ///
    /// - Parameter color: UIColor
    /// - Returns: Myself
    public func buttonTextColor(_ color: UIColor?) -> Self {
        _inner._alertController.view.tintColor = color
        return self
    }
    
    /// Change title text color
    ///
    /// - Parameter color: UIColor
    /// - Returns: Myself
    public func titleTextColor(_ color: UIColor?) -> Self {
        _inner._alertController.titleTextColor = color
        return self
    }
    
    /// Change message text color
    ///
    /// - Parameter color: UIColor
    /// - Returns: Myself
    public func messageTextColor(_ color: UIColor?) -> Self {
        _inner._alertController.messageTextColor = color
        return self
    }
    
    /// Change text alignment of title
    ///
    /// - Parameter alignment: NSTextAlignment
    /// - Returns: Myself
    public func titleTextAlignment(_ alignment: NSTextAlignment) -> Self {
        _inner._alertController.titleTextAlignment = alignment
        return self
    }
    
    /// Change text alignment of message
    ///
    /// - Parameter alignment: NSTextAlignment
    /// - Returns: Myself
    public func messageTextAlignment(_ alignment: NSTextAlignment) -> Self {
        _inner._alertController.messageTextAlignment = alignment
        return self
    }

    
    /// Show alert (or action sheet).
    ///
    /// - Parameters:
    ///   - viewController: The view controller to display over the current view controller’s content. Default is **UIApplication.shared.keyWindow?.rootViewController**
    ///   - completion: The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify nil for this parameter.
    public func show(on viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController, completion: (() -> Void)? = nil) {
        if _inner._alertController.preferredStyle == .actionSheet && UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
            if _inner._alertController.popoverPresentationController?.sourceView == nil {
                _inner._alertController.popoverPresentationController?.sourceView = viewController?.view
            }
        }
        viewController?.present(_inner._alertController, animated: true, completion: completion)
    }
    
    /// Build **UIAlertAction** using **Alertift.Action** and handler.
    ///
    /// - Parameters:
    ///   - action: action
    ///   - handler: The handler to execute after the action selected.
    /// - Returns: **UIAlertAction**
    func buildAlertAction(_ action: Alertift.Action, handler: Alertift.Action.Handler?) -> UIAlertAction {
        return action.buildAlertAction(handler:
            handler.map { ActionHandlerBuilder.build($0, _inner._alertController.finallyExecutor)
        })
    }
}
