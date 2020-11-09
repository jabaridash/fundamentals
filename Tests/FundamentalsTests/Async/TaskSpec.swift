//
//  TaskSpec.swift
//  FundamentalsTests
//
//  Created by jabari on 11/6/20.
//

import Foundation
import Nimble
import Quick

@testable import Fundamentals

final class TaskSpec: QuickSpec {
    override func spec() {
        describe("A Task") {
            var subject: Task<Int, MockError>!
            var result: Result<Int, MockError>!
            var taskComplete: Bool!
            
            beforeEach {
                taskComplete = false
                result = .success(1)
                
                subject = .init { completion in
                    completion(result)
                }
            }
            
            context("when chaining tasks with flatMap()") {
                it("chaining multiple tasks behaves as expected") {
                    let task: Task<Int, Error> = .just(-2)
                    
                    func absoluteValue(_ int: Int) -> Task<Int, Error> {
                        return .just(abs(int))
                    }
                    
                    func squared(_ int: Int) -> Task<Int, Error> {
                        .init { completion in
                            DispatchQueue.global(qos: .background).async {
                                completion(.success(int * int))
                            }
                        }
                    }
                    
                    func toString(_ int: Int) -> Task<String, Error> {
                        return .just("value: \(int)")
                    }
                    
                    let finalTask = task.flatMap(absoluteValue)
                                        .flatMap(squared)
                                        .flatMap(toString)
                    
                    waitUntil { done in
                        finalTask.perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == "value: 4"
                            done()
                        }
                    }
                }
                
                it("completion runs on correct DispatchQueue") {
                    let queue = DispatchQueue(label: "the-queue", attributes: .concurrent)
                    let task: Task<Int, Error> = .just(1)
                    
                    waitUntil { done in
                        task.flatMap { _ in Task<String, Error>.just("some-string") }.perform(queue: queue) { _ in
                            expect(DispatchQueue.currentLabel) == "the-queue"
                            done()
                        }
                    }
                }
                
                it("tasks are executed in sequence") {
                    waitUntil { done in
                        let task: Task<Int, Error> = .just(1)
                        
                        task.flatMap { Task<String, Error>.just("value: \($0)") }.perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == "value: 1"
                            done()
                        }
                    }
                }
                
                it("errors are handled properly") {
                    let task: Task<String, MockError> = (Task<Int, MockError>).just(1).flatMap { _ in
                        return .init {
                            $0(.failure(MockError.basicError))
                        }
                    }
                    
                    waitUntil { done in
                        task.perform { result in
                            guard case let .failure(error) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(error as MockError) == .basicError
                            done()
                        }
                    }
                }
            }
            
            context("when recovering from a failed task") {
                it("resolves correct recovery value") {
                    waitUntil { done in
                        Task<Int, MockError> { $0(.failure(.basicError)) }
                        .recover { _ in return 1 }
                        .perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == 1
                            done()
                        }
                    }
                }
                
                it("completion runs on correct DispatchQueue") {
                    let queue = DispatchQueue(label: "the-queue", attributes: .concurrent)
                    let task: Task<Int, MockError> = .error(.basicError)
                    
                    waitUntil { done in
                        task
                            .recover { _ in 1}
                            .perform(queue: queue) { _ in
                            expect(DispatchQueue.currentLabel) == "the-queue"
                            done()
                        }
                    }
                }
            }
            
            context("when merging tasks") {
                var task1: Task<Int, Error>!
                var task2: Task<Int, Error>!
                var task3: Task<Int, Error>!
                var task4: Task<Int, Error>!
                
                beforeEach {
                    task1 = .just(1)
                    task2 = .just(2)
                    task3 = .just(3)
                    task4 = .just(4)
                }
                
                it("completion runs on correct DispatchQueue") {
                    let q1 = DispatchQueue(label: "q1", attributes: .concurrent)
                    let q2 = DispatchQueue(label: "q2", attributes: .concurrent)
                    let q3 = DispatchQueue(label: "q3", attributes: .concurrent)
                    
                    let t1: Task<Int, Error> = .init { callback in q1.async { callback (.success(1)) } }
                    let t2: Task<Int, Error> = .init { callback in q2.async { callback (.success(1)) } }
                    let tasks = [t1, t2].map { $0.map { $0 as Any } }

                    let t3 = Task<Any, Error>.merge(tasks)
                    
                    waitUntil { done in
                        t3.perform(queue: q3) { _ in
                            expect(DispatchQueue.currentLabel) == "q3"
                            done()
                        }
                    }
                }
                
                it("merges array of tasks with Task.merge") {
                    let tasks = [
                        task1!,
                        task2!,
                        task3!,
                        task4!,
                    ].map { $0.map { $0 as Any } }
                                        
                    waitUntil { done in
                        Task<Any, Error>.merge(tasks).perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            let actual = value as! [Int]
                            let expected = [1, 2, 3, 4]
                            
                            expect(actual) == expected
                            done()
                        }
                    }
                }
                
                it("merges 2 tasks with Task.all") {
                    waitUntil { done in
                        Task<(Int, Int), Error>.all(task1, task2).perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value.0) == 1
                            expect(value.1) == 2
                            done()
                        }
                    }
                }
                
                it("merges 3 tasks with Task.all") {
                    waitUntil { done in
                        Task<(Int, Int), Error>.all(task1, task2, task3).perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value.0) == 1
                            expect(value.1) == 2
                            expect(value.2) == 3
                            done()
                        }
                    }
                }
                
                it("merges 4 tasks with Task.all") {
                    waitUntil { done in
                        Task<(Int, Int), Error>.all(task1, task2, task3, task4).perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value.0) == 1
                            expect(value.1) == 2
                            expect(value.2) == 3
                            expect(value.3) == 4
                            done()
                        }
                    }
                }
            }
            
            context("async / await") {
                var actual: [Int]!
                var queue: DispatchQueue!
                var task1: Task<Void, Error>!
                var task2: Task<Void, Error>!
                var task3: Task<Void, Error>!
                var failingTask: Task<Void, Error>!
                
                beforeEach {
                    queue = DispatchQueue(label: "some-queue", attributes: .concurrent)
                    actual = []
                    
                    task1 = .init { completion in
                        queue.async {
                            actual.append(1)
                            completion(.success(()))
                        }
                    }
                    
                    task2 = .init { completion in
                        queue.async {
                            actual.append(2)
                            completion(.success(()))
                        }
                    }
                    
                    task3 = .init { completion in
                        queue.async {
                            actual.append(3)
                            completion(.success(()))
                        }
                    }
                    
                    failingTask = .error(MockError.basicError)
                }
                
                it("runs tasks in sequence") {
                    async {
                        try await(task1)
                        try await(task2)
                        try await(task3)
                    }
                    
                    expect(actual).toEventually(equal([1, 2, 3]))
                }
                
                it("stops execution after first failing task") {
                    async {
                        try await(task1)
                        try await(failingTask)
                        try await(task2)
                        try await(task3)
                    }
                    
                    expect(actual).toEventually(equal([1]))
                }
                        
                it("handles void return type properly") {
                    var sum: Int!

                    async {
                        let one = try await(.just(1))
                        let two = try await(.just(2))
                        
                        sum = one + two
                    }
                    
                    expect(sum).toEventually(equal(3))
                }
                
                it("returns value properly") {
                    waitUntil { done in
                        async {
                            (try await(.just(1))) + (try await(.just(2)))
                        }
                        .perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == 3
                            done()
                        }
                    }
                }
                
                it("handles error properly") {
                    waitUntil { done in
                        async {
                            (try await(.just(1))) + (try await(.error(MockError.basicError)))
                        }
                        .perform { result in
                            guard case let .failure(error) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(error as? MockError) == .basicError
                            done()
                        }
                    }
                }
            }
            
            context("when calling .error()") {
                it("the correct error is resolved") {
                    subject = .error(MockError.basicError)
                    
                    waitUntil { done in
                        subject.perform { result in
                            guard case let .failure(error) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(error) == MockError.basicError
                            done()
                        }
                    }
                }
            }
            
            context("when calling .just()") {
                it("the correct error is resolved") {
                    subject = .just(1)
                    
                    waitUntil { done in
                        subject.perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == 1
                            done()
                        }
                    }
                }
            }
            
            context("when calling mapError()") {
                it("the new error error is resolved") {
                    subject = .error(MockError.basicError)
                    
                    waitUntil { done in
                        subject
                            .mapError { _ in MappedError.anotherError }
                            .perform { result in
                            guard case let .failure(error) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(error) == .anotherError
                            done()
                        }
                    }
                }
                
                it("original value is still resolved") {
                    subject = .just(1)
                    
                    waitUntil { done in
                        subject
                            .mapError { _ in MappedError.anotherError }
                            .perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == 1
                            done()
                        }
                    }
                }
            }
            
            context("when calling map()") {
                it("completion runs on correct DispatchQueue") {
                    let queue = DispatchQueue(label: "the-queue", attributes: .concurrent)
                    let task: Task<Int, MockError> = .just(1)
                    
                    waitUntil { done in
                        task
                            .map { 2 * $0 }
                            .perform(queue: queue) { _ in
                            expect(DispatchQueue.currentLabel) == "the-queue"
                            done()
                        }
                    }
                }
                
                it("new value is returned") {
                    subject = .just(1)
                    
                    waitUntil { done in
                        subject
                            .map { "\(2 * $0)" }
                            .perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == "2"
                            done()
                        }
                    }
                }
                
                it("error can be re-cast back to original error type") {
                    subject = .error(MockError.basicError)
                    
                    waitUntil { done in
                        subject
                            .map { 2 * $0 }
                            .perform { result in
                            guard case let .failure(error) = result else {
                                fail("\(result)")
                                return
                            }
            
                            expect(error as? MockError) == .basicError
                            done()
                        }
                    }
                }
                
                it("new error type can be resolved if map() throws") {
                    subject = .just(1)
                    
                    waitUntil { done in
                        subject.map { _ in throw MappedError.anotherError }.perform { result in
                            guard case let .failure(error as MappedError) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(error) == .anotherError
                            done()
                        }
                    }
                }
            }
            
            context("when calling perform()") {
                it("completion runs on correct DispatchQueue") {
                    let queue = DispatchQueue(label: "the-queue", attributes: .concurrent)
                    let otherQueue = DispatchQueue(label: "other-queue", attributes: .concurrent)
                    
                    let task: Task<Int, MockError> = .init { completion in
                        queue.async {
                            completion(.success(1))
                        }
                    }
                    
                    waitUntil { done in
                        task.perform(queue: otherQueue) { _ in
                            expect(DispatchQueue.currentLabel) == "other-queue"
                            done()
                        }
                    }
                }
                
                it("completion is called") {
                    subject.perform { result in
                        taskComplete = true
                    }
                    
                    expect(taskComplete).toEventually(equal(true))
                }
                
                it("value is properly resolved") {
                    result = .success(10)
                    
                    waitUntil { done in
                        subject.perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == 10
                            done()
                        }
                    }
                }
                
                it("completion is called on proper dispatch queue when specified") {
                    let queue = DispatchQueue(label: "abc")
                    let key = DispatchSpecificKey<String>()
                    
                    queue.setSpecific(key: key, value: "abc-key")
                    
                    waitUntil { done in
                        subject.perform(queue: queue) { result in
                            expect(DispatchQueue.getSpecific(key: key)) == "abc-key"
                            done()
                        }
                    }
                }
            }
        }
    }
}

private enum MappedError: Error, Equatable {
    case anotherError
}

private extension DispatchQueue {
    static var currentLabel: String {
        return String(cString: __dispatch_queue_get_label(nil), encoding: .utf8)!
    }
}
