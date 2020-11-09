//
//  MockFatalError.swift
//  FundamentalsTests
//
//  Created by jabari on 11/7/20.
//

import Foundation

// https://stackoverflow.com/questions/32873212/unit-test-fatalerror-in-swift

#if DEBUG
internal struct FatalErrorUtil {
    static var fatalErrorClosure: (String, StaticString, UInt) -> Never = defaultFatalErrorClosure
    
    private static let defaultFatalErrorClosure = {
        Swift.fatalError($0, file: $1, line: $2)
    }
    
    static func replaceFatalError(closure: @escaping (String, StaticString, UInt) -> Never) {
        fatalErrorClosure = closure
    }

    static func restoreFatalError() {
        fatalErrorClosure = defaultFatalErrorClosure
    }
}

internal func unreachable() -> Never {
    repeat {
        RunLoop.current.run()
    } while (true)
}


internal func fatalError(
    _ message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    return FatalErrorUtil.fatalErrorClosure(message(), file, line)
}
#endif
