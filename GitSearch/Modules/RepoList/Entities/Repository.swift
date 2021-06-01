//
//  Repository.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

struct Repository: Decodable {
    let allowMergeCommit, allowRebaseMerge, allowSquashMerge: Bool?
    let archiveUrl: String
    let archived: Bool
    let assigneesUrl, blobsUrl, branchesUrl, cloneUrl, collaboratorsUrl,
        commentsUrl, commitsUrl, compareUrl, contentsUrl, contributorsUrl: String
    let createdAt: Date
    let defaultBranch: String
    let deleteBranchOnMerge: Bool?
    let deploymentsUrl: URL
    let description: String?
    let disabled: Bool
    let downloadsUrl, eventsUrl: URL
    let fork: Bool
    let forks, forksCount: Int
    let forksUrl: URL
    let fullName: String
    let gitCommitsUrl, gitRefsUrl, gitTagsUrl, gitUrl: String
    let hasDownloads, hasIssues, hasPages, hasProjects: Bool
    let hasWiki: Bool
    let homepage: String?
    let hooksUrl: String
    let htmlUrl: URL
    let id: Int
    let issueCommentUrl, issueEventsUrl, issuesUrl, keysUrl, labelsUrl: String
    let language: String?
    let languagesUrl: String
    let license: License?
    let masterBranch: String?
    let mergesUrl, milestonesUrl: String
    let mirrorUrl: String?
    let name, nodeId: String
    let notificationsUrl: String
    let openIssues, openIssuesCount: Int
    let owner: User?
    let permissions: Permissions?
    let `private`: Bool
    let pullsUrl: String
    let pushedAt: Date
    let releasesUrl: String
    let score: Double
    let size: Int
    let sshUrl: String
    let stargazersCount: Int
    let stargazersUrl, statusesUrl, subscribersUrl, subscriptionUrl,
        svnUrl, tagsUrl, teamsUrl: String
    let tempCloneToken: String?
    let textMatches: [SearchResultTextMatch]?
    let topics: [String]?
    let treesUrl: String
    let updatedAt: Date
    let url: String
    let watchers, watchersCount: Int
}

extension Repository: Hashable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - License

struct License: Decodable {
    let htmlUrl: URL?
    let key, name, nodeId: String
    let spdxId, url: String?
}

// MARK: - User

struct User: Decodable {
    let avatarUrl, eventsUrl, followersUrl, followingUrl, gistsUrl: String
    let gravatarId: String?
    let htmlUrl: URL
    let id: Int
    let login, nodeId: String
    let organizationsUrl, receivedEventsUrl, reposUrl: String
    let siteAdmin: Bool
    let starredAt: String?
    let starredUrl, subscriptionsUrl: String
    let type: String
    let url: String
}

// MARK: - Permissions

struct Permissions: Decodable {
    let admin, pull, push: Bool
}

// MARK: - SearchResultTextMatch

struct SearchResultTextMatch: Decodable {
    let fragment: String?
    let matches: [Match]?
    let objectType, objectUrl: String
    let property: String?
    
    struct Match: Decodable {
        let indices: [Int]?
        let text: String?
    }
}
