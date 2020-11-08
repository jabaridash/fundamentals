//
//  Logger.swift
//  Core
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - LoggerProtocol

protocol LoggerProtocol {
    func all(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    func trace(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    func debug(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    func info(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    func warn(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    func error(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    func fatal(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
}

// MARK: - Helper implentations

extension LoggerProtocol {
    func all(
        _ message: CustomStringConvertible,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line,
        columnNumber: Int = #column
    ) {
        all(message, fileName: fileName, functionName: functionName, lineNumber: lineNumber, columnNumber: columnNumber)
    }
    
    func trace(
        _ message: CustomStringConvertible,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line,
        columnNumber: Int = #column
    ) {
        trace(message, fileName: fileName, functionName: functionName, lineNumber: lineNumber, columnNumber: columnNumber)
    }
    
    func debug(
        _ message: CustomStringConvertible,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line,
        columnNumber: Int = #column
    ) {
        debug(message, fileName: fileName, functionName: functionName, lineNumber: lineNumber, columnNumber: columnNumber)
    }
    
    func info(
        _ message: CustomStringConvertible,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line,
        columnNumber: Int = #column
    ) {
        info(message, fileName: fileName, functionName: functionName, lineNumber: lineNumber, columnNumber: columnNumber)
    }
    
    func warn(
        _ message: CustomStringConvertible,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line,
        columnNumber: Int = #column
    ) {
        warn(message, fileName: fileName, functionName: functionName, lineNumber: lineNumber, columnNumber: columnNumber)
    }
    
    func error(
        _ message: CustomStringConvertible,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line,
        columnNumber: Int = #column
    ) {
        self.error(message, fileName: fileName, functionName: functionName, lineNumber: lineNumber, columnNumber: columnNumber)
    }
    
    func fatal(
        _ message: CustomStringConvertible,
        fileName: String = #file,
        functionName: String = #function,
        lineNumber: Int = #line,
        columnNumber: Int = #column
    ) {
        self.fatal(message, fileName: fileName, functionName: functionName, lineNumber: lineNumber, columnNumber: columnNumber)
    }
}
