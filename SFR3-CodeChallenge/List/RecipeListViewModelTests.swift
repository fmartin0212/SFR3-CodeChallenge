//
//  RecipeListViewModelTests.swift
//  SFR3-CodeChallengeTests
//
//  Created by Frank Martin on 8/26/24.
//

@testable import SFR3_CodeChallenge
import XCTest

class RecipeListViewModelTests: BaseTestCase {
    @MainActor
    var vm = RecipeListViewModel()

    @MainActor
    func testSearchAndPaging() async {
        let data = testRecipesJSON.data(using: .utf8)!
        urlSession.enqueueResponseForRequest(response: (data, .success))
        await vm.searchTextSubmitted("Pasta")
        
        XCTAssertEqual(vm.model.searchText, "Pasta")
        XCTAssertFalse(vm.model.isLoading)
        XCTAssertFalse(vm.model.showError)
        XCTAssertEqual(vm.model.recipes.map(\.id), [716429, 715538, 715539, 715531, 715532, 715533, 715534, 715535, 715536, 715537])
        XCTAssertEqual(vm.model.totalResults, 16)
        
        // Test paging state
        XCTAssertEqual(vm.model.offset, 10)
        XCTAssertEqual(vm.model.resultsReceived, 10)
        XCTAssertEqual(vm.model.remainingResults, 6)
        XCTAssertEqual(vm.model.recipeRequestCount, 6)
        XCTAssertTrue(vm.model.hasNextPage)
        
        let secondPage = testRecipesSecondPageJSON.data(using: .utf8)!
        urlSession.enqueueResponseForRequest(response: (secondPage, .success))
        await vm.getNextPage()
        
        XCTAssertEqual(vm.model.recipes.map(\.id), [716429, 715538, 715539, 715531, 715532, 715533, 715534, 715535, 715536, 715537, 1, 2, 3, 4, 5, 6])
        
        // Test paging state
        XCTAssertEqual(vm.model.offset, 16)
        XCTAssertEqual(vm.model.resultsReceived, 16)
        XCTAssertEqual(vm.model.remainingResults, 0)
        XCTAssertEqual(vm.model.recipeRequestCount, 0)
        XCTAssertFalse(vm.model.hasNextPage)
    }
    
    @MainActor 
    func testPicker() {
        XCTAssertEqual(vm.model.state, .api)
        
        vm.stateSelected(.favorites)
        
        XCTAssertEqual(vm.model.state, .favorites)
    }
    
    @MainActor
    func testError() async {
        let invalidData = "invalid"
        let data = invalidData.data(using: .utf8)!
        
        urlSession.enqueueResponseForRequest(response: (data, .success))
        
        await vm.searchTextSubmitted("")
        
        XCTAssertTrue(vm.model.showError)
        XCTAssertFalse(vm.model.isLoading)
        XCTAssertEqual(vm.model.recipes.count, 0)
        
        let retryData = testRecipesJSON.data(using: .utf8)!
        urlSession.enqueueResponseForRequest(response: (retryData, .success))
        await vm.searchTextSubmitted("Pasta") // Simulating a retry
 
        XCTAssertFalse(vm.model.showError)
        XCTAssertEqual(vm.model.recipes.map(\.id), [716429, 715538, 715539, 715531, 715532, 715533, 715534, 715535, 715536, 715537])
    }
}
