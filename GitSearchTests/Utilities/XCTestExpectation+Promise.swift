//
//  XCTestExpectation+Promise.swift
//  GitSearchTests
//
//  Created by Peter Bloxidge on 05/06/2021.
//

import XCTest
import PromiseKit

extension XCTestCase {

    func shortWait(for expectation: XCTestExpectation) {
        wait(for: [expectation], timeout: 0.5)
    }
}

extension XCTestCase {

    func waitFor<T>(_ promise: Promise<T>, function: String = #function) {
        let expectation = expectation(description: "\(function) Promise")
        
        promise.ensure {
            expectation.fulfill()
        }.cauterize()
        
        shortWait(for: expectation)
    }

    func waitFor<T>(_ promise: Promise<T>,
                    _ capturedResult: inout T?,
                    _ capturedError: inout Error?,
                    function: String = #function) {
        let expectation = expectation(description: "\(function) Promise")

        var closureResult: T?
        var closureError: Error?

        promise.done { result in
            closureResult = result
            expectation.fulfill()
        }.catch { error in
            closureError = error
            expectation.fulfill()
        }
        
        shortWait(for: expectation)

        if let result = closureResult {
            capturedResult = result
        }
        if let error = closureError {
            capturedError = error
        }
    }
}
