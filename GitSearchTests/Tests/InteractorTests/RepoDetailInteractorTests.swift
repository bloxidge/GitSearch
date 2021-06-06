//
//  RepoDetailInteractorTests.swift
//  GitSearchTests
//
//  Created by Peter Bloxidge on 06/06/2021.
//

import XCTest
@testable import GitSearch
import PromiseKit
import SwiftyMocky

class RepoDetailInteractorTests: XCTestCase {
    
    var sut: RepoDetailInteractor!
    
    let apiMock = ApiServiceMock()
    
    private let repoStub = RepositoryFixtures.repo

    override func setUp() {
        super.setUp()
        
        sut = RepoDetailInteractorImpl(api: apiMock)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func testfetchReadmeContentRequestValid() {
        // Given
        //   API will return anything
        Given(apiMock, .send(request: .any(Request<RepositoryContent>.self),
                             willReturn: .pending().promise))
        
        // When
        //   fetchReadmeContent method called
        _ = sut.fetchReadmeContent(for: repoStub)

        // Then
        //   It should send a correct request
        let matcher = RequestMatcher<RepositoryContent>(method: .get,
                                                        path: "repos/\(repoStub.owner!.login)/\(repoStub.name)/readme")
        Verify(apiMock, .send(request: matcher.getParameter()))
    }
    
    func testfetchReadmeContentSuccess() {
        // Given
        //   API will return valid response
        let expectedResponse = RepositoryContentFixtures.repoContent
        Given(apiMock, .send(request: .any(Request<RepositoryContent>.self),
                             willReturn: Promise.value(expectedResponse)))
        
        // When
        //   fetchReadmeContent method resolves
        var capturedResult: String?
        var capturedError: Error?
        waitFor(sut.fetchReadmeContent(for: repoStub),
                &capturedResult,
                &capturedError)

        // Then
        //   It should return correctly decoded result
        XCTAssertEqual(capturedResult, RepositoryContentFixtures.decodedString)

        // And
        //   It should not throw an error
        XCTAssertNil(capturedError)
        
        // And
        //   Result should be cached in local variable
        XCTAssertEqual(sut.readmeContentString, capturedResult)
    }
    
    func testfetchReadmeContentError() {
        // Given
        //   API will return an error
        Given(apiMock, .send(request: .any(Request<RepositoryContent>.self),
                             willReturn: Promise(error: ApiError.invalidResponse)))
        
        // When
        //   fetchReadmeContent method resolves
        var capturedResult: String?
        var capturedError: Error?
        waitFor(sut.fetchReadmeContent(for: repoStub),
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
        XCTAssertNil(sut.readmeContentString)
    }
    
    func testfetchReadmeContentBase64DecodingError() {
        // Given
        //   API will return valid response
        let expectedResponse = RepositoryContentFixtures.invalidContent
        Given(apiMock, .send(request: .any(Request<RepositoryContent>.self),
                             willReturn: Promise.value(expectedResponse)))
        
        // When
        //   fetchReadmeContent method resolves
        var capturedResult: String?
        var capturedError: Error?
        waitFor(sut.fetchReadmeContent(for: repoStub),
                &capturedResult,
                &capturedError)
        
        // Then
        //   It should throw a `Base64EncodingError.dataCorrupted` error
        XCTAssertEqual(capturedError as? Base64DecodingError, .dataCorrupted)

        // And
        //   It should not return a valid result
        XCTAssertNil(capturedResult)
        
        // And
        //   Result should not be cached in local variable
        XCTAssertNil(sut.readmeContentString)
    }
}
