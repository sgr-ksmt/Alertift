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

        public typealias Handler = (UIAlertAction, Int) -> Void

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
        public func action(_ action: Alertift.Action, handler: Handler? = nil) -> Self {
            return self.action(action, image: nil, handler: handler)
        }

        /// Add action to alertController
        public func action(_ action: Alertift.Action, image: UIImage?, renderingMode: UIImage.RenderingMode = .automatic, handler: Handler? = nil) -> Self {
            let alertAction = buildAlertAction(action, handler:
                merge(_alertController.actionHandler, handler ?? { (_, _) in })
            )

            if let image = image {
                alertAction.setValue(image.withRenderingMode(renderingMode), forKey: "image")
            }

            _alertController.addAction(alertAction)
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

        /// Add sourceView and sourceRect to **popoverPresentationController** using anchorView.
        ///
        /// If you want to use action sheet on iPad, you have to use this method.
        /// - Parameters:
        ///   - anchorView: will be anchor of popoverPresentationController.
        /// - Returns: Myself
        public func popover(anchorView: UIView) -> Self {
            _alertController.popoverPresentationController?.sourceView = anchorView.superview
            _alertController.popoverPresentationController?.sourceRect = anchorView.frame
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
        
        func convertFinallyHandler(_ handler: Any) -> InnerAlertController.FinallyHandler {
            return { (action, index, _) in  (handler as? Handler)?(action, index) }
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
