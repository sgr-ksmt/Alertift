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
            showActionSheet(anchorView: button)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Alertift.alert(title: "Alertift", message: "Alertift is swifty, modern, and awesome UIAlertController wrapper.")
            .image(#imageLiteral(resourceName: "alertImage"))
            .titleTextColor(.red)
            .messageTextColor(.blue)
            .action(.default("❤")) { (action, index, _) in
                print(action, index)
            }
            .action(.default("⭐")) { (action, index, _) in
                print(action, index)
            }
            .finally { [weak self] (action, index, _) in
                print(action, index)
                self?.showAlertWithActionImage()
            }
            .show(on: self)
    }
    
    private func showSimpleAlert() {
        Alertift.alert(title: "Sample 1", message: "Simple alert!")
            .image(#imageLiteral(resourceName: "alertImage"))
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
            .action(.default("Sign in")) { (_, _, textFields) in
                let id = textFields?.first?.text ?? ""
                let password = textFields?.last?.text ?? ""
                Alertift.alert(title: "Sign in successfully", message: "ID: \(id)\nPassword: \(password)")
                    .action(.default("OK"))
                    .show()
            }
            .show()
    }

    private func showAlertWithActionImage() {
        Alertift.alert(message: "Can use image in alert action")
            .action(.default("info"), image: #imageLiteral(resourceName: "icon"))
            .show(on: self)
    }

    private func showActionSheet(anchorView: UIView) {
        Alertift.actionSheet(message: "Which food do you like?", anchorView: anchorView)
            .action(.default("🍣"), image: #imageLiteral(resourceName: "icon"))
            .action(.default("🍎"), image: #imageLiteral(resourceName: "icon"))
            .action(.default("🍖"), image: #imageLiteral(resourceName: "icon"))
            .action(.default("🍅"), image: #imageLiteral(resourceName: "icon"))
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

