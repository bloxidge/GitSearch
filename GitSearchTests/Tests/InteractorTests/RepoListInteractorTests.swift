//
//  RepoListInteractorTests.swift
//  GitSearchTests
//
//  Created by Peter Bloxidge on 05/06/2021.
//

import XCTest
@testable import GitSearch
import PromiseKit
import SwiftyMocky

class RepoListInteractorTests: XCTestCase {
    
    var sut: RepoListInteractor!
    
    let apiMock = ApiServiceMock()

    override func setUp() {
        super.setUp()
        
        sut = RepoListInteractorImpl(api: apiMock)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func testfetchRepoSearchResultsRequestValid() {
        // Given
        //   API will return anything
        Given(apiMock, .send(request: .any(Request<RepositorySearchResults>.self),
                             willReturn: .pending().promise))
        
        // When
        //   fetchRepoSearchResults method called
        _ = sut.fetchRepoSearchResults("SearchString",
                                       sort: .helpWantedIssues,
                                       order: .ascending)

        // Then
        //   It should send a correct request
        let matcher = RequestMatcher<RepositorySearchResults>(method: .get,
                                                              path: "search/repositories",
                                                              queryValidator: { queryParams in
            return queryParams["q"] == "SearchString" &&
                queryParams["sort"] == "help-wanted-issues" &&
                queryParams["order"] == "asc" &&
                queryParams["per_page"] == nil &&
                queryParams["page"] == "1"
        })
        Verify(apiMock, .send(request: matcher.getParameter()))
    }
    
    func testfetchRepoSearchResultsSuccess() {
        // Given
        //   API will return valid response
        let expectedResponse = RepositoryFixtures.searchResults
        Given(apiMock, .send(request: .any(Request<RepositorySearchResults>.self),
                             willReturn: Promise.value(expectedResponse)))
        
        // When
        //   fetchRepoSearchResults method resolves
        var capturedResult: RepositorySearchResults?
        var capturedError: Error?
        waitFor(sut.fetchRepoSearchResults(""),
                &capturedResult,
                &capturedError)

        // Then
        //   It should return correct result
        XCTAssertEqual(capturedResult, expectedResponse)

        // And
        //   It should not throw an error
        XCTAssertNil(capturedError)
        
        // And
        //   Result should be cached in local variable
        XCTAssertEqual(sut.fullResults, capturedResult)
    }
    
    func testfetchRepoSearchResultsError() {
        // Given
        //   API will return an error
        Given(apiMock, .send(request: .any(Request<RepositorySearchResults>.self),
                             willReturn: Promise(error: ApiError.invalidResponse)))
        
        // When
        //   fetchRepoSearchResults method resolves
        var capturedResult: RepositorySearchResults?
        var capturedError: Error?
        waitFor(sut.fetchRepoSearchResults(""),
                &capturedResult,
                &capturedError)
        
        // Then
        //   It should throw an error
        XCTAssertNotNil(capturedError)

        // And
        //   It should not return a valid result
        XCTAssertNil(capturedResult)
        
        // And
        //   Result should not be cached in local variable
        XCTAssertNil(sut.fullResults)
    }

    func testfetchNextPageResultsRequestValid() {
        // Given
        //   API will return valid response
        let expectedResponse = RepositoryFixtures.searchResults
        Given(apiMock, .send(request: .any(Request<RepositorySearchResults>.self),
                             willReturn: Promise.value(expectedResponse)))

        // And
        //   fetchRepoSearchResults method fulfills with results
        waitFor(sut.fetchRepoSearchResults("RepoName",
                                           sort: .updated,
                                           order: .descending))
        apiMock.resetMock(.invocation) // Ignore first invocation of api request

        // When
        //   fetchNextPageResults method called
        _ = sut.fetchNextPageResults()

        // Then
        //   It should send a correct request with "page" incremented to 2
        let matcher = RequestMatcher<RepositorySearchResults>(method: .get,
                                                              path: "search/repositories",
                                                              queryValidator: { queryParams in
            return queryParams["q"] == "RepoName" &&
                queryParams["sort"] == "updated" &&
                queryParams["order"] == "desc" &&
                queryParams["per_page"] == nil &&
                queryParams["page"] == "2"
        })
        Verify(apiMock, .send(request: matcher.getParameter()))
    }

    func testfetchNextPageResultsSuccess() {
        // Given
        //   API will return valid response
        let expectedResponse = RepositoryFixtures.searchResults
        Given(apiMock, .send(request: .any(Request<RepositorySearchResults>.self),
                             willReturn: Promise.value(expectedResponse)))

        // And
        //   fetchRepoSearchResults method fulfills with results
        var initialResult: RepositorySearchResults?
        var initialError: Error?
        waitFor(sut.fetchRepoSearchResults(""),
                &initialResult,
                &initialError)

        // When
        //   fetchNextPageResults method resolves
        var capturedResult: Void?
        var capturedError: Error?
        waitFor(sut.fetchNextPageResults(),
                &capturedResult,
                &capturedError)

        // Then
        //   It should not throw an error
        XCTAssertNil(capturedError)

        // And
        //   Full results should be cached in local variable with items
        //   accrued with previous results for this search
        XCTAssertEqual(sut.fullResults?.items, initialResult!.items + expectedResponse.items)
    }

    func testfetchNextPageResultsErrorNoInitialSearch() {
        // Given
        //   API will return valid response
        let expectedResponse = RepositoryFixtures.searchResults
        Given(apiMock, .send(request: .any(Request<RepositorySearchResults>.self),
                             willReturn: Promise.value(expectedResponse)))

        // When
        //   fetchNextPageResults method resolves without previously calling fetchRepoSearchResults
        var capturedResult: Void?
        var capturedError: Error?
        waitFor(sut.fetchNextPageResults(),
                &capturedResult,
                &capturedError)

        // Then
        //   It should throw a `RepoSearchError.missingInitialSearch` error
        XCTAssertEqual(capturedError as? RepoSearchError, .missingInitialSearch)
    }
}
