//
//  Logger.swift
//  Core
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - Logger

public final class Logger {
    public static let shared: Logger = .init()
    
    private let configuration: Configuration
    internal let dispatchQueue: DispatchQueue?
    
    init(configuration: Configuration = .default) {
        self.configuration = configuration
        self.dispatchQueue = configuration.executionMode == .asynchronous ?
            DispatchQueue(label: "\(type(of: self)) - \(UUID().uuidString)") : nil
    }
}

// MARK: - Conform Logger to LoggerProtocol

extension Logger: LoggerProtocol {
    func all(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .all,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    func trace(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .trace,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    func debug(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .debug,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    func info(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .info,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    func warn(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .warn,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    func error(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
        self.log(
            message,
            logLevel: .error,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber,
            columnNumber: columnNumber
        )
    }
    
    func fatal(_ message: CustomStringConvertible, fileName: String, functionName: String, lineNumber: Int, columnNumber: Int) {
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
    struct Configuration {
        public let logLevel: Level
        public let executionMode: ExecutionMode
        public let dateFormatter: DateFormatter
        
        public static let `default`: Configuration = .init(
            logLevel: .default,
            executionMode: .default,
            dateFormatter: .logFormatter
        )
    }
}

// MARK: - Logger.Level

public extension Logger {
    enum ExecutionMode {
        case asynchronous
        case synchronous
        
        static let `default`: ExecutionMode = {
            #if DEBUG
            return .synchronous
            #else
            return .asynchronous
            #endif
        }()
    }
    
    enum Level: Int, CustomStringConvertible {
        case all
        case trace
        case debug
        case info
        case warn
        case error
        case fatal
        
        static let `default`: Level = {
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
    static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        return formatter
    }()
}

#if DEBUG
internal extension Logger {
    static var messages: [String] = []
}

func print(_ object: CustomStringConvertible) {
    if isRunningTests && shouldRecordLoggedMessage {
        Logger.messages.append(String(describing: object))
    }
    
    Swift.print(object)
}
#endif

internal extension Date {
    #if DEBUG
    static func now() -> Date {
        guard isRunningTests else {
            return Date()
        }
        
        // Monday, October 30, 1995 3:31:00 PM EST
        return Date(timeIntervalSince1970: 815085060)
    }
    
    #else
    static func now() -> Date {
        return Date()
    }
    #endif
}

#if DEBUG
internal var isRunningTests: Bool {
    return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
}

internal var shouldRecordLoggedMessage = false
#endif
