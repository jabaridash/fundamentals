//
//  Logger.swift
//  Fundamentals
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - LoggerProtocol

public protocol LoggerProtocol {
    /// Logs a message with the `ALL` log level.
    /// - Parameters:
    ///   - message: Specified message to log.
    ///   - fileName: The name of file that the function was called from.
    ///   - functionName: The name of the function that called this function.
    ///   - lineNumber: The line number in the file that called this function.
    ///   - columnNumber: The column (character number) of the line within the file that called this function.
    func all(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    /// Logs a message with the `TRACE` log level.
    /// - Parameters:
    ///   - message: Specified message to log.
    ///   - fileName: The name of file that the function was called from.
    ///   - functionName: The name of the function that called this function.
    ///   - lineNumber: The line number in the file that called this function.
    ///   - columnNumber: The column (character number) of the line within the file that called this function.
    func trace(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    /// Logs a message with the `DEBUG` log level.
    /// - Parameters:
    ///   - message: Specified message to log.
    ///   - fileName: The name of file that the function was called from.
    ///   - functionName: The name of the function that called this function.
    ///   - lineNumber: The line number in the file that called this function.
    ///   - columnNumber: The column (character number) of the line within the file that called this function.
    func debug(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    /// Logs a message with the `INFO` log level.
    /// - Parameters:
    ///   - message: Specified message to log.
    ///   - fileName: The name of file that the function was called from.
    ///   - functionName: The name of the function that called this function.
    ///   - lineNumber: The line number in the file that called this function.
    ///   - columnNumber: The column (character number) of the line within the file that called this function.
    func info(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    /// Logs a message with the `WARN` log level.
    /// - Parameters:
    ///   - message: Specified message to log.
    ///   - fileName: The name of file that the function was called from.
    ///   - functionName: The name of the function that called this function.
    ///   - lineNumber: The line number in the file that called this function.
    ///   - columnNumber: The column (character number) of the line within the file that called this function.
    func warn(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    /// Logs a message with the `ERROR` log level.
    /// - Parameters:
    ///   - message: Specified message to log.
    ///   - fileName: The name of file that the function was called from.
    ///   - functionName: The name of the function that called this function.
    ///   - lineNumber: The line number in the file that called this function.
    ///   - columnNumber: The column (character number) of the line within the file that called this function.
    func error(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
    
    /// Logs a message with the `FATAL` log level.
    /// - Parameters:
    ///   - message: Specified message to log.
    ///   - fileName: The name of file that the function was called from.
    ///   - functionName: The name of the function that called this function.
    ///   - lineNumber: The line number in the file that called this function.
    ///   - columnNumber: The column (character number) of the line within the file that called this function.
    func fatal(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int)
}

// MARK: - Helper implentations

public extension LoggerProtocol {
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
