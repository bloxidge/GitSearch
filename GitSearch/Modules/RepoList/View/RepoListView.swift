//
//  RepoListView.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

enum RepoListViewState: Equatable {
    case initial
    case loading
    case doneResults
    case doneEmpty
    case error
}

protocol RepoListView: AnyObject {
    func updateView(state: RepoListViewState)
}
