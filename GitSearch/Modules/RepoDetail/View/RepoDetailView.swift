//
//  RepoDetailView.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

enum RepoDetailViewState: Equatable {
    case initial(Repository)
}

protocol RepoDetailView: AnyObject {
    func updateView(state: RepoDetailViewState)
}
