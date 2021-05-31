//
//  HttpHeader.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

enum HttpHeader: Equatable {
    case contentType(ContentType)
    
    func getHeader() -> (key: String, value: String) {
        switch self {
        case .contentType(let type):
            return (key: "Content-Type", value: type.rawValue)
        }
    }

}

enum ContentType: String {
    case json = "application/json"
}

extension Array where Element == HttpHeader {

    func toMap() -> [String : String] {
        return reduce(into: [:]) { (result, header) in
            let (key, value) = header.getHeader()
            result[key] = value
        }
    }
}
