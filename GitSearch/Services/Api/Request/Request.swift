//
//  Request.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

class Request<ResponseType: Decodable> {
        
    var method: HttpMethod {
        return .get
    }
    
    var path: String {
        fatalError("Must override path")
    }
    
    var headers: [HttpHeader] {
        return []
    }
    
    var queryParameters: [String : String]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
}

struct EmptyResponse: Decodable {}
