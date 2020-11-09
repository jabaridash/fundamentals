//
//  Logger.swift
//  Fundamentals
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - Logger

/// Configurable logger that enables logging at specified logging levels.
public final class Logger {
    /// Shared singleton instance of `Logger`.
    public static let shared: Logger = .init()
    
    /// `DispatchQueue` on which `log()` will be called on if the `Logger` is
    ///  configured with the asynchronous execution mode.
    internal let dispatchQueue: DispatchQueue?
    
    /// `Configuration` with which the `Logger` was initialized. This influences the behavior of the `Logger`.
    private let configuration: Configuration
    
    /// Initializes a `Logger` with a specified configuration. If no configuration is supplied,
    /// then `Configuration.default` will be used.
    /// - Parameter configuration: The specified configuration.
    init(configuration: Configuration = .default) {
        self.configuration = configuration
        self.dispatchQueue = configuration.executionMode == .asynchronous ?
            DispatchQueue(label: "\(type(of: self)) - \(UUID().uuidString)") : nil
    }
}

// MARK: - Conform Logger to LoggerProtocol

extension Logger: LoggerProtocol {
    public func all(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .all,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    public func trace(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .trace,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    public func debug(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .debug,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    public func info(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .info,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    public func warn(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .warn,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    public func error(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .error,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    public func fatal(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .fatal,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
}

// MARK: - Private helpers

private extension Logger {
    /// Logs a message with a specified the log level. If the specified `LogLevel` is below the `LogLevel`
    /// that was specified in the `Configuration` of this `Logger`, no message will be logged.
    /// - Parameters:
    ///   - message: Specified message to log.
    ///   - logLevel: Level at which the message should be logged.
    ///   - fileName: The name of file that the function was called from.
    ///   - functionName: The name of the function that called this function.
    ///   - lineNumber: The line number in the file that called this function.
    ///   - columnNumber: The column (character number) of the line within the file that called this function.
    func log(
        _ message: CustomStringConvertible,
        logLevel: Level,
        fileName: String,
        functionName: String,
        lineNumber: Int,
        columnNumber: Int
    ) {
        guard logLevel.rawValue >= configuration.logLevel.rawValue else { return }
                
        let work = { [weak self, message, logLevel, fileName, functionName] in
            guard let self = self else { return }
            
            var prefix = fileName
            
            if let file = fileName.split(separator: "/").last {
                prefix = String(file)
            }
            
            let date = self.configuration.dateFormatter.string(from: .now())
                            
            print("\(date) \(logLevel) \(prefix):\(functionName) - \(message)")
        }
        
        switch configuration.executionMode {
        case .asynchronous:
            dispatchQueue?.async(execute: work)
        case .synchronous:
            work()
        }
    }
}

// MARK: - Logger.Configuration

public extension Logger {
    /// Details how to configure an instance of `Logger`.
    struct Configuration {
        /// Minimum logging level that the log at.
        ///
        /// For example, if the minimum log level is `.error`, calls to `info()` will be a no-op.
        public let logLevel: Level
        
        /// The mode that logging should be executed in. Logging can occur synchronously or asynchronously.
        ///
        /// In both cases, calls will be executed in a serial fashion. Meaning, `warn()` is called before
        /// `info()`, the warning message will be logged prior to the info message. For performance purposes,
        /// `.asynchronous` is the preferred approach. The `.synchronous` mode is most useful for debugging purposes.
        public let executionMode: ExecutionMode
        
        /// Specifies how dates should be formatted when a message is logged.
        public let dateFormatter: DateFormatter
        
        /// Default configuration for a `Logger`.
        public static let `default`: Configuration = .init(
            logLevel: .default,
            executionMode: .default,
            dateFormatter: .logFormatter
        )
    }
}

// MARK: - Logger.Level

/// Default implementation of `LoggerProtocol`.
public extension Logger {
    /// Determines how messages should be logged.
    enum ExecutionMode {
        /// Messages will be logged on a serial queue in the background.
        case asynchronous
        
        /// Messages will be logged synchronous on the same dispatch queue that the log function was called from.
        case synchronous
        
        /// The default behavior for production applications is `.asynchronous`. `.synchronous` is used for debugging.
        public static let `default`: ExecutionMode = {
            #if DEBUG
            return .synchronous
            #else
            return .asynchronous
            #endif
        }()
    }
    
    /// Specifies the minimum level at which the `Logger` should log messages. For a given level,
    /// if a calling function attempts to call one of the log functions that represent a lower level
    /// than the minimum level for the `Logger`, no message will be logged.
    enum Level: Int, CustomStringConvertible {
        case all
        case trace
        case debug
        case info
        case warn
        case error
        case fatal
        
        /// Default level for `Logger`. For debugging, the `.debug` level will be used. For production,
        /// the `.info` level will be used.
        public static let `default`: Level = {
            #if DEBUG
            return .debug
            #else
            return .info
            #endif
        }()

        public var description: String {
            switch self {
            case .all: return "ALL"
            case .trace: return "TRACE"
            case .debug: return "DEBUG"
            case .info: return "INFO"
            case .warn: return "WARN"
            case .error: return "ERROR"
            case .fatal: return "FATAL"
            }
        }
    }
}

internal extension DateFormatter {
    /// The default `DateFormatter` that is used when added the date to a logged message.
    static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter
    }()
}

// MARK: - Helper logic for the purposes of testability.

/*
 It is challenging to unit test the Logger class because it depends on the print() function.
 To get around this we can "replace" the implementation of print() will an implementation that
 stores the printed messages. This way, we can check that the messages were printed properly.
 
 It is also challenging to unit test things based on Date, as that may be highly specific to the
 time and locale in which the code is running. To get around this, we have a wrapper function around
 the default initializer of Date called now(). This way, we can optionally replace the default
 implementation that returns the same date every time if we are running in test mode.
*/

#if DEBUG
// MARK: - Flags

/// Returns `true` if the code that is running is in a test environment.
internal var isRunningTests: Bool {
    return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}

/// Flag that enables storing every message that is sent to the `print()` function.
internal var shouldRecordLoggedMessage = false

/// Flag that allows overriding the behavior of `now()` such that it always returns
/// the same `Date` for predictability while testing.
internal var shouldOverrideDate = false

// MARK: - print() logic

internal extension Logger {
    static var messages: [String] = []
}

internal func print(_ object: CustomStringConvertible) {
    if isRunningTests && shouldRecordLoggedMessage {
        Logger.messages.append(String(describing: object))
    }
    
    Swift.print(object)
}

// MARK: - Date logic

private extension Date {
    static func now() -> Date {
        guard isRunningTests && shouldOverrideDate else {
            return Date()
        }
        
        // Monday, October 30, 1995 3:31:00 PM EST
        return Date(timeIntervalSince1970: 815085060)
    }
}
#else
private extension Date {
    static func now() -> Date {
        return Date()
    }
}
#endif
