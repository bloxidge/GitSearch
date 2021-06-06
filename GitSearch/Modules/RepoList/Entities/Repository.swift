//
//  Repository.swift
//  GitSearch
//
//  Created by Peter Bloxidge on 31/05/2021.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let fullName: String
    let name: String
    let description: String?
    let htmlUrl: URL
    let owner: User?
    let forksCount: Int
    let stargazersCount: Int
    let updatedAt: Date
/*
    let allowMergeCommit, allowRebaseMerge, allowSquashMerge: Bool?
    let archiveUrl: String
    let archived: Bool
    let assigneesUrl, blobsUrl, branchesUrl, cloneUrl, collaboratorsUrl,
        commentsUrl, commitsUrl, compareUrl, contentsUrl, contributorsUrl: String
    let createdAt: Date
    let defaultBranch: String
    let deleteBranchOnMerge: Bool?
    let deploymentsUrl: URL
    let disabled: Bool
    let downloadsUrl, eventsUrl: URL
    let fork: Bool
    let forks: Int
    let forksUrl: URL
    let gitCommitsUrl, gitRefsUrl, gitTagsUrl, gitUrl: String
    let hasDownloads, hasIssues, hasPages, hasProjects: Bool
    let hasWiki: Bool
    let homepage: String?
    let hooksUrl: String
    let issueCommentUrl, issueEventsUrl, issuesUrl, keysUrl, labelsUrl: String
    let language: String?
    let languagesUrl: String
    let license: License?
    let masterBranch: String?
    let mergesUrl, milestonesUrl: String
    let mirrorUrl: String?
    let nodeId: String
    let notificationsUrl: String
    let openIssues, openIssuesCount: Int
    let permissions: Permissions?
    let `private`: Bool
    let pullsUrl: String
    let pushedAt: Date
    let releasesUrl: String
    let score: Double
    let size: Int
    let sshUrl: String
    let stargazersUrl, statusesUrl, subscribersUrl, subscriptionUrl,
        svnUrl, tagsUrl, teamsUrl: String
    let tempCloneToken: String?
    let textMatches: [SearchResultTextMatch]?
    let topics: [String]?
    let treesUrl: String
    let url: String
    let watchers, watchersCount: Int
 */
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
    let id: Int
    let login: String
    let avatarUrl: String
/*
    let eventsUrl, followersUrl, followingUrl, gistsUrl: String
    let gravatarId: String?
    let htmlUrl: URL
    let nodeId: String
    let organizationsUrl, receivedEventsUrl, reposUrl: String
    let siteAdmin: Bool
    let starredAt: String?
    let starredUrl, subscriptionsUrl: String
    let type: String
    let url: String
 */
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
