//
//  RepoDetailPresenterTests.swift
//  GitSearchTests
//
//  Created by Peter Bloxidge on 25/05/2021.
//

import XCTest
@testable import GitSearch
import PromiseKit
import PMKFoundation
import SwiftyMocky

class RepoDetailPresenterTests: XCTestCase {
    
    var sut: RepoDetailPresenter!
    
    let view = RepoDetailViewMock()
    let interactor = RepoDetailInteractorMock()
    let router = RepoDetailRouterMock()

    override func setUp() {
        super.setUp()
        
        let presenter = RepoDetailPresenterImpl(repository: RepositoryFixtures.repo)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        sut = presenter
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    func testOnViewDidLoad() {
        // When
        //   Presenter is attached to view
        sut.attachToView()

        // Then
        //   View should get an .initial state update callback
        Verify(view, .updateView(state: .value(.initial)))
    }
    
    func testLoadReadmeSuccessState() {
        // Given
        //   Interactor returns decoded README string
        Given(interactor, .fetchReadmeContent(for: .any,
                                              willReturn: Promise.value(RepositoryContentFixtures.decodedString)))
        
        // When
        //   Presenter is requested to load README
        waitFor(sut.loadReadme())
        
        // Then
        //   Interactor should request README for stored repository
        Verify(interactor, .fetchReadmeContent(for: .value(sut.repository)))

        // And
        //   View should receive view state update callbacks for `.loading` and `.readmeSuccess`
        Verify(view, .updateView(state: .value(.loading)))
        Verify(view, .updateView(state: .value(.readmeSuccess)))
    }
    
    func testLoadReadmeFailedNotFoundState() {
        // Given
        //   Interactor returns a 404 'Not found' error
        let notFoundError = PMKHTTPError.badStatusCode(404, Data(), HTTPURLResponse())
        Given(interactor, .fetchReadmeContent(for: .any,
                                              willReturn: Promise(error: notFoundError)))
        
        // When
        //   Presenter is requested to load README
        waitFor(sut.loadReadme())

        // And
        //   View should receive view state update callbacks for `.loading` and `.readmeNotFound`
        Verify(view, .updateView(state: .value(.loading)))
        Verify(view, .updateView(state: .value(.readmeNotFound)))
    }
    
    func testLoadReadmeFailedErrorState() {
        // Given
        //   Interactor returns any other error
        Given(interactor, .fetchReadmeContent(for: .any,
                                              willReturn: Promise(error: Base64DecodingError.dataCorrupted)))
        
        // When
        //   Presenter is requested to load README
        waitFor(sut.loadReadme())

        // And
        //   View should receive view state update callbacks for `.loading` and `.readmeSuccess`
        Verify(view, .updateView(state: .value(.loading)))
        Verify(view, .updateView(state: .value(.error)))
    }
    
    func testgetVisibleResults() {
        // Given
        //   Interactor has cached value for `readmeContentString`
        Given(interactor, .readmeContentString(getter: RepositoryContentFixtures.decodedString))
        
        // Then
        //   Method should return stored README decoded string
        XCTAssertEqual(sut.getRawReadme(), RepositoryContentFixtures.decodedString)
    }
    
    func testDidPressClose() {
        // When
        //   Presenter receives close button pressed
        sut.didPressClose()
        
        // Then
        //   Router should dismiss detail screen
        Verify(router, .dismissDetail())
    }
}
