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
    typealias AdjustInfo = (lineCount: Int, height: CGFloat)

    /// - Return: value that was set on `title`
    private(set) var originalTitle: String?
    private var spaceAdjustedTitle: String = ""
    private(set) var originalMessage: String?
    private var spaceAdjustedMessage: String = ""

    private weak var imageView: UIImageView? = nil
    private var previousImgViewSize: CGSize = .zero

    override var title: String? {
        didSet {
            if title != spaceAdjustedTitle {
                originalTitle = title
            }
        }
    }

    override var message: String? {
        didSet {
            if message != spaceAdjustedMessage {
                originalMessage = message
            }
        }
    }

    public func setImage(_ image: UIImage?) {
        if let _ = image, title == nil {
            title = " "
        }
        guard let imageView = self.imageView else {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            self.view.addSubview(imageView)
            self.imageView = imageView
            imageView.alpha = 0.5
            return
        }
        imageView.image = image
        imageView.frame.size = image?.size ?? .zero
    }

    // MARK: -  Layout code

    override func viewDidLayoutSubviews() {
        guard let imageView = imageView, let _ = imageView.image else {
            super.viewDidLayoutSubviews()
            return
        }

        adjustImageViewPosition()
        super.viewDidLayoutSubviews()
    }

    private func adjustImageViewPosition() {
        guard let imageView = imageView, let image = imageView.image else {
            return
        }

        if imageView.frame.width > view.frame.width {
            imageView.frame.size.width = view.frame.width
            imageView.frame.size.height = imageView.frame.size.width * image.size.height / image.size.width
        }

        // Adjust title if image size has changed
        if previousImgViewSize != imageView.bounds.size {
            previousImgViewSize = imageView.bounds.size
            let info = adjustLabel(for: imageView)
            imageView.center.x = view.bounds.width / 2.0
            imageView.center.y = Constants.padding(for: preferredStyle) + info.height / 2.0
        }
    }

    private func adjustLabel(for imageView: UIImageView) -> AdjustInfo {

        if let label = titleLabel {
            let info = getLineCountAndHeight(for: imageView, label: label)
            let lines = String(repeating: "\n", count: info.lineCount)
            spaceAdjustedTitle = lines + (originalTitle ?? "")
            title = spaceAdjustedTitle
            return info
        } else if let label = messageLabel {
            let info = getLineCountAndHeight(for: imageView, label: label)
            let lines = String(repeating: "\n", count: info.lineCount)
            spaceAdjustedMessage = lines + (originalMessage ?? "")
            message = spaceAdjustedMessage
            return info
        } else {
            return (0, 0.0)
        }
    }

    private func getLineCountAndHeight(for imageView: UIImageView, label: UILabel?) -> AdjustInfo {
        guard let label = label else {
            return (0, 0.0)
        }
        let _label = UILabel(frame: .zero)
        _label.font = label.font
        _label.text = ""
        _label.numberOfLines = 0
        var lineCount = 1
        while _label.frame.height < imageView.frame.height {
            _label.text = _label.text.map { $0 + "\n" }
            _label.sizeToFit()
            lineCount += 1
        }
        return (lineCount, _label.frame.height)
    }

    private lazy var lineHeight: CGFloat = {
        return titleLabel?.font.lineHeight ?? messageLabel?.font.lineHeight ?? 1.0
    }()

    struct Constants {
        static var paddingAlert: CGFloat = 20
        static var paddingSheet: CGFloat = 10
        static func padding(for style: UIAlertControllerStyle) -> CGFloat {
            return style == .alert ? Constants.paddingAlert : Constants.paddingSheet
        }
    }






    /// textFieldTextDidChangeHandler: ((UITextField, Int) -> Void)
    var textFieldTextDidChangeHandler: Alertift.Alert.TextFieldHandler?
    
    public typealias FinallyHandler = (UIAlertAction, Int, [UITextField]?) -> Void
    var finallyHandler: FinallyHandler?

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

    /// Returns actionHandler
    var actionHandler: (UIAlertAction) -> (UIAlertAction, Int) {
        return { [weak self] action in (action, self?.actions.index(of: action) ?? -1) }
    }

    /// Returns actionWithTextFieldsHandler
    var actionWithTextFieldsHandler: (UIAlertAction) -> (UIAlertAction, Int, [UITextField]?) {
        return { [weak self] action in (action, self?.actions.index(of: action) ?? -1, self?.textFields) }
    }
    
    /// Returns finallyExecutor
    var finallyExecutor: (UIAlertAction) -> Void {
        return { [weak self] action in
            self?.finallyHandler?(action, self?.actions.index(of: action) ?? -1, self?.textFields)
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
