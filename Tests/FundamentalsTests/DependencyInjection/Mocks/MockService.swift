//
//  MockService.swift
//  FundamentalsTests
//
//  Created by jabari on 11/7/20.
//

protocol MockServiceProtocol {}
protocol MockControllerProtocol {}
final class MockService: MockServiceProtocol {}
final class MockController: MockControllerProtocol, MockServiceProtocol {}
