//
//  RepoDetailView.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

enum RepoDetailViewState: Equatable {
    case initial
    case loading
    case readmeSuccess
    case readmeNotFound
    case error
}

protocol RepoDetailView: AnyObject, AutoMockable {
    func updateView(state: RepoDetailViewState)
}
