//
//  RepoDetailInteractor.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation
import PromiseKit

protocol RepoDetailInteractor: AutoMockable {
    var readmeContentString: String? { get }
    
    func fetchReadmeContent(for repository: Repository) -> Promise<String>
}

class RepoDetailInteractorImpl: RepoDetailInteractor {
    
    var readmeContentString: String?
        
    let api: ApiService
    
    init(api: ApiService) {
        self.api = api
    }
    
    func fetchReadmeContent(for repository: Repository) -> Promise<String> {
        let request = GetRepositoryReadmeRequest(for: repository)
        
        return api.send(request: request)
            .map { contentResponse -> String in
                let base64Content = contentResponse.content.replacingOccurrences(of: "\n", with: "")
                      
                guard let data = Data(base64Encoded: base64Content),
                      let decodedContent = String(data: data, encoding: .utf8) else {
                    throw Base64DecodingError.dataCorrupted
                }
                return decodedContent
            }
            .map {
                self.readmeContentString = $0
                return $0
            }
    }
}

enum Base64DecodingError: Error {
    case dataCorrupted
}
