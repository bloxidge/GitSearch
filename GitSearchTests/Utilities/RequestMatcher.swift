//
//  RequestMatcher.swift
//  GitSearchTests
//
//  Created by Peter Bloxidge on 05/06/2021.
//

import Foundation
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
            self.method == request.method
                && self.path == request.path
                && self.specificHeaders.allSatisfy { request.headers.contains($0) }
                && self.requestQueryParamsValid(request.queryParameters)
                && self.requestBodyValid(request.body)
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
