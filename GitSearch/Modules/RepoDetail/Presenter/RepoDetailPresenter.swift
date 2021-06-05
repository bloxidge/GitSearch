//
//  RepoDetailPresenter.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation
import PromiseKit
import PMKFoundation

protocol RepoDetailPresenter {
    var repository: Repository { get }
    
    func attachToView()
    func loadReadme()
    func getRawReadme() -> String?
    func didPressClose()
}

class RepoDetailPresenterImpl: RepoDetailPresenter {
    
    weak var view: RepoDetailView!
    var interactor: RepoDetailInteractor!
    var router: RepoDetailRouter!
    
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func attachToView() {
        view.updateView(state: .initial)
    }
    
    func loadReadme() {
        view.updateView(state: .loading)
        
        interactor.fetchReadmeContentFile(for: repository)
            .done { _ in
                self.view.updateView(state: .readmeSuccess)
            }
            .catch { error in
                if let httpError = error as? PMKHTTPError,
                   case .badStatusCode(let code, _, _) = httpError, code == 404 {
                    self.view.updateView(state: .readmeNotFound)
                } else {
                    print(error)
                    self.view.updateView(state: .error)
                }
            }
    }
    
    func getRawReadme() -> String? {
        let content = interactor.readmeFileContents?.content
        guard let base64Content = content?.replacingOccurrences(of: "\n", with: ""),
              let data = Data(base64Encoded: base64Content),
              let decodedContent = String(data: data, encoding: .utf8) else {
            return nil
        }
        return decodedContent
    }
    
    func didPressClose() {
        router.dismissDetail()
    }
}
