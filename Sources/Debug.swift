//
//  Debug.swift
//  Alertift
//
//  Created by Suguru Kishimoto on 4/28/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

/// Logger for debug
final class Debug {
    static var isEnabled = false
    static func log(_ msg: @autoclosure () -> String = "", _ file: @autoclosure () -> String = #file, _ line: @autoclosure () -> Int = #line, _ function: @autoclosure () -> String = #function) {
        if isEnabled {
            let fileName = file().components(separatedBy: "/").last ?? ""
            print("[Debug] [\(fileName):\(line())]#\(function()) \(msg())")
        }
    }
}
