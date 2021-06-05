//
//  ApiService.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import UIKit
import PromiseKit
import PMKFoundation

protocol ApiService {
    func send<ResponseType: Decodable>(request: Request<ResponseType>) -> Promise<ResponseType>
}

class ApiServiceImpl: ApiService {
    
    static var shared: ApiService = {
        return ApiServiceImpl(requestBuilder: URLRequestBuilderImpl())
    }()
    
    let requestBuilder: URLRequestBuilder
    let urlSession: URLSession
    
    private let config = ApiConfig()
    
    init(requestBuilder: URLRequestBuilder,
         urlSession: URLSession = .shared) {
        self.requestBuilder = requestBuilder
        self.urlSession = urlSession
    }
    
    func send<ResponseType>(request: Request<ResponseType>) -> Promise<ResponseType> where ResponseType : Decodable {
        firstly { () -> Promise<(data: Data, response: URLResponse)> in
            let urlRequest = try requestBuilder.build(from: request, baseUrl: config.baseUrl)
            return urlSession.dataTask(.promise, with: urlRequest)
        }
        .validate()
        .map { (data, _) in
            try self.config.decoder.decode(ResponseType.self, from: data)
        }
    }
}
