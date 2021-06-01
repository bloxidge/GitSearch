//
//  URLRequestBuilder.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation
import PromiseKit

protocol URLRequestBuilder {
    func build<T: Decodable>(from request: Request<T>, baseUrl: String) throws -> URLRequest
}

class URLRequestBuilderImpl: URLRequestBuilder {

    func build<T: Decodable>(from request: Request<T>, baseUrl: String) throws -> URLRequest {
        guard let url = URL(string: "\(baseUrl)/\(request.path)"),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        
        components.percentEncodedQueryItems = request.queryParameters?
            .map {
                let encodedValue = $1.addingPercentEncoding(withAllowedCharacters: .rfc3986Unreserved) ?? ""
                return URLQueryItem(name: $0, value: encodedValue)
            }

        var urlRequest = URLRequest(url: components.url ?? url)
        urlRequest.httpMethod = request.method.rawValue.uppercased()
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.headers.toMap()
        return urlRequest
    }
}

private extension CharacterSet {
    
    static var rfc3986Unreserved: CharacterSet = {
        return CharacterSet(charactersIn: "-_.~").union(.alphanumerics)
    }()
}
