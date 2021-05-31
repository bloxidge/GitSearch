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
    
    let requestBuilder: URLRequestBuilder
    let urlSession: URLSession
    let decoder: JSONDecoder
    
    init(requestBuilder: URLRequestBuilder,
         urlSession: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.requestBuilder = requestBuilder
        self.urlSession = urlSession
        self.decoder = decoder
    }
    
    func send<ResponseType>(request: Request<ResponseType>) -> Promise<ResponseType> where ResponseType : Decodable {
        firstly { () -> Promise<(data: Data, response: URLResponse)> in
            let urlRequest = try requestBuilder.build(from: request, baseUrl: ApiConfig.baseUrl)
            return urlSession.dataTask(.promise, with: urlRequest)
        }
        .validate()
        .map { (data, _) in
            try self.decoder.decode(ResponseType.self, from: data)
        }
    }
}
