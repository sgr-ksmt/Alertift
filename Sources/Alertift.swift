//
//  Alertift.swift
//  Alertift
//
//  Created by Suguru Kishimoto on 4/26/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation


/// Alertift
/// make alert or action sheet.
public final class Alertift {    
    /// private initializer
    private init() {}
    
    /// Make alert
    ///
    /// - Parameters:
    ///   - title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    ///   - message: Descriptive text that provides additional details about the reason for the alert.
    /// - Returns: Instance of **Alert**
    public static func alert(title: String? = nil, message: String? = nil) -> Alert {
        return Alert(title: title, message: message)
    }

    /// Make action sheet
    ///
    /// - Parameters:
    ///   - title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    ///   - message: Descriptive text that provides additional details about the reason for the alert.
    /// - Returns: Instance of **ActionSheet**
    public static func actionSheet(title: String? = nil, message: String? = nil) -> ActionSheet {
        return ActionSheet(title: title, message: message)
    }

    /// Make action sheet
    ///
    /// - Parameters:
    ///   - title: The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    ///   - message: Descriptive text that provides additional details about the reason for the alert.
    ///   - anchorView: will be anchor of popoverPresentationController.
    /// - Returns: Instance of **ActionSheet**
    public static func actionSheet(title: String? = nil, message: String? = nil, anchorView: UIView) -> ActionSheet {
        return actionSheet(title: title, message: message).popover(anchorView: anchorView)
    }
}
