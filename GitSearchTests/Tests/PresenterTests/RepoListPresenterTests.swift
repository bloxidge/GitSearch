//
//  RepoListPresenterTests.swift
//  GitSearchTests
//
//  Created by Peter Bloxidge on 25/05/2021.
//

import XCTest
@testable import GitSearch
import PromiseKit
import SwiftyMocky

class RepoListPresenterTests: XCTestCase {
    
    var sut: RepoListPresenter!
    
    let view = RepoListViewMock()
    let interactor = RepoListInteractorMock()
    let router = RepoListRouterMock()

    override func setUp() {
        super.setUp()
        
        let presenter = RepoListPresenterImpl()
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
    
    func testPerformSearchSuccessPopulatedResultsState() {
        // Given
        //   Interactor returns non-empty results
        Given(interactor, .fetchRepoSearchResults(.any, sort: .any, order: .any, resultsPerPage: .any, page: .any,
                                                  willReturn: Promise.value(RepositoryFixtures.searchResults)))
        
        // When
        //   Presenter is requested to perform search
        waitFor(sut.performSearch(""))

        // Then
        //   View should receive view state update callbacks for `.loading` and `.doneResults`
        Verify(view, .updateView(state: .value(.loading)))
        Verify(view, .updateView(state: .value(.doneResults)))
    }
    
    func testPerformSearchSuccessEmptyResultsState() {
        // Given
        //   Interactor returns no results
        Given(interactor, .fetchRepoSearchResults(.any, sort: .any, order: .any, resultsPerPage: .any, page: .any,
                                                  willReturn: Promise.value(RepositoryFixtures.searchResultsEmpty)))
        
        // When
        //   Presenter is requested to perform search
        waitFor(sut.performSearch(""))

        // Then
        //   View should receive view state update callbacks for `.loading` and `.doneEmpty`
        Verify(view, .updateView(state: .value(.loading)))
        Verify(view, .updateView(state: .value(.doneEmpty)))
    }
    
    func testPerformSearchFailedErrorState() {
        // Given
        //   Interactor returns an error
        Given(interactor, .fetchRepoSearchResults(.any, sort: .any, order: .any, resultsPerPage: .any, page: .any,
                                                  willReturn: Promise(error: ApiError.invalidResponse)))
        
        // When
        //   Presenter is requested to perform search
        waitFor(sut.performSearch(""))

        // Then
        //   View should receive view state update callbacks for `.loading` and `.doneEmpty`
        Verify(view, .updateView(state: .value(.loading)))
        Verify(view, .updateView(state: .value(.error)))
    }
    
    func testRepeatLastSearch() {
        // Given
        //   Interactor returns results
        Given(interactor, .fetchRepoSearchResults(.any, sort: .any, order: .any, resultsPerPage: .any, page: .any,
                                                  willReturn: Promise.value(RepositoryFixtures.searchResults)))
        
        // When
        //   Presenter is requested to repeat last search if no initial search occurred
        waitFor(sut.repeatLastSearch()) 
        
        // Then
        //   No search request is made
        Verify(interactor, 0, .fetchRepoSearchResults(.any, sort: .any, order: .any, resultsPerPage: .any, page: .any))
        
        // When
        //   Presenter is requested to repeat last search after a search has occurred
        waitFor(sut.performSearch(""))
        waitFor(sut.repeatLastSearch())

        // Then
        //   View should receive view state update callbacks for `.loading` and `.doneResults` twice
        Verify(view, 2, .updateView(state: .value(.loading)))
        Verify(view, 2, .updateView(state: .value(.doneResults)))
    }
    
    func testGetVisibleResults() {
        let results = RepositoryFixtures.searchResults
        
        // Given
        //   Interactor has cached value for `results`
        Given(interactor, .results(getter: results))
        
        // Then
        //   Method should return items in `results`
        XCTAssertEqual(sut.getVisibleResults(), results.items)
    }
    
    func testGetRepositoryAtIndex() {
        let results = RepositoryFixtures.searchResults
        
        // Given
        //   Interactor has cached value for `results`
        Given(interactor, .results(getter: results))
        
        // Then
        //   Method should return repository at index in `results.items`
        XCTAssertEqual(sut.getRepository(at: 2), results.items[2])
    }
    
    func testDidSelectRepository() {
        let selectedRepo = RepositoryFixtures.repo
        
        // When
        //   Presenter receives selected repository
        sut.didSelect(repository: selectedRepo)

        // Then
        //   Router should present detail screen for selected repository
        Verify(router, .presentDetail(for: .value(selectedRepo)))
    }
}
