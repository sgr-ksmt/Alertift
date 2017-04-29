//
//  ViewController.swift
//  Demo
//
//  Created by Suguru Kishimoto on 4/26/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import UIKit
import Alertift

class ViewController: UIViewController {
    
    @IBOutlet private var buttons: [UIButton]! {
        didSet {
            buttons.enumerated().forEach { index, button in
                button.tag = index
                button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
            }
        }
    }
    private enum AlertType: Int {
        case simple
        case yesOrNo
        case login
        case actionsheet
    }
    
    @objc private func buttonDidTap(_ button: UIButton) {
        guard let type = AlertType(rawValue: button.tag) else {
            return
        }
        
        switch type {
        case .simple:
            showSimpleAlert()
        case .yesOrNo:
            showYesOrNoAlert()
        case .login:
            showLoginAlert()
        case .actionsheet:
            showActionSheet(source: self.view, frame: button.frame)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Alertift.alert(title: "Alertift", message: "Alertift is swifty, modern, and awesome UIAlertController wrapper.")
            .action(.default("❤"))
            .action(.default("⭐"))
            .show(on: self)
    }
    
    private func showSimpleAlert() {
        Alertift.alert(title: "Sample 1", message: "Simple alert!")
            .action(.default("OK"))
            .show()
    }
    
    private func showYesOrNoAlert() {
        Alertift.alert(title: "Sample 2",message: "Do you like 🍣?")
            .action(.default("Yes"), isPreferred: true) {
                Alertift.alert(message: "🍣🍣🍣")
                    .action(.default("Close"))
                    .show()
            }
            .action(.cancel("No")) {
                Alertift.alert(message: "😂😂😂")
                    .action(.destructive("Close"))
                    .show()
            }
            .show()
    }
    
    private func showLoginAlert() {
        Alertift.alert(title: "Sign in", message: "Input your ID and Password")
            .textField { textField in
                textField.placeholder = "ID"
            }
            .textField { textField in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            }
            .handleTextFieldTextDidChange { textField, index in
                let text = textField.text ?? ""
                print("\(index), \(text)")
            }
            .action(.cancel("Cancel"))
            .action(.default("Sign in"), textFieldsHandler: { textFields in
                let id = textFields?.first?.text ?? ""
                let password = textFields?.last?.text ?? ""
                Alertift.alert(title: "Sign in successfully", message: "ID: \(id)\nPassword: \(password)")
                    .action(.default("OK"))
                    .show()
            })
            .show()
    }
    private func showActionSheet(source: UIView, frame: CGRect) {
     Alertift.actionSheet(message: "Which food do you like?")
        .popover(sourceView: source, sourceRect: frame)
        .action(.default("🍣"))
        .action(.default("🍎"))
        .action(.default("🍖"))
        .action(.default("🍅"))
        .action(.cancel("None of them"))
        .finally { action, index in
            if action.style == .cancel {
                return
            }
            Alertift.alert(message: "\(index). \(action.title!)")
                .action(.default("OK"))
                .show()
        }
        .show()
    }
}

