//
//  Logger.swift
//  Core
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - LoggerProtocol

protocol LoggerProtocol {
    func all()
    func trace()
    func debug()
    func info()
    func warn()
    func error()
    func fatal()
    func off()
}
