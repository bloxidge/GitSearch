//
//  RequestMatcher.swift
//  GitSearchTests
//
//  Created by Peter Bloxidge on 05/06/2021.
//

import XCTest
@testable import GitSearch
import SwiftyMocky

struct RequestMatcher<Response: Decodable> {

    private let method: HttpMethod
    private let path: String
    private let specificHeaders: [HttpHeader]
    private let queryValidator: (([String : String]) -> Bool)?
    private let bodyValidator: ((Data) -> Bool)?
    
    init(method: HttpMethod,
         path: String,
         specificHeaders: [HttpHeader] = [],
         queryValidator: (([String : String]) -> Bool)? = nil,
         bodyValidator: ((Data) -> Bool)? = nil) {
        self.method = method
        self.path = path
        self.specificHeaders = specificHeaders
        self.queryValidator = queryValidator
        self.bodyValidator = bodyValidator
    }

    func getParameter() -> Parameter<Request<Response>> {
        return .matching { request in
            XCTAssertEqual(self.method, request.method)
            XCTAssertEqual(self.path, request.path)
            XCTAssert(self.specificHeaders.allSatisfy { request.headers.contains($0) })
            XCTAssert(self.requestQueryParamsValid(request.queryParameters))
            XCTAssert(self.requestBodyValid(request.body))
            return true
        }
    }

    private func requestQueryParamsValid(_ queryParams: [String : String]?) -> Bool {
        guard let queryParams = queryParams else {
            return true
        }
        return queryValidator?(queryParams) ?? true
    }

    private func requestBodyValid(_ body: Data?) -> Bool {
        guard let body = body else {
            return true
        }
        return bodyValidator?(body) ?? true
    }
}
