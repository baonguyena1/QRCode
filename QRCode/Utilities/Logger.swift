//
//  Logger.swift
//  GetzPOS
//
//  Created by Bao Nguyen on 7/19/17.
//  Copyright © 2017 Getz Group Pte. Ltd. All rights reserved.
//

import UIKit

// Define prefix of Log
enum LogEvent: String {
    case e = "[ERROR]" // error
    case i = "[INFO]" // info
    case d = "[DEBUG]" // debug
    case v = "[VERBOSE]" // verbose
    case w = "[WARNING]" // warning
    case s = "[SERVER]" // server
}

final class Logger {
    fileprivate static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    
    fileprivate static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    // Get file name
    fileprivate class func sourceFileName(_ filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    static func log(_ message: Any, event: LogEvent = .d,
                    fileName: String = #file,
                    line: Int = #line,
                    column: Int = #column,
                    funcName: String = #function) {
        #if DEBUG
            print("\(Date().string()) Main Thread: \(Thread.isMainThread) \(event.rawValue)[\(sourceFileName(fileName))]:\(line) \(column) \(funcName) : \(message)")
        #endif
    }
}

private extension Date {
    func string() -> String {
        return Logger.dateFormatter.string(from: self)
    }
}

