//
//  RecipeListViewModel.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import Foundation

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var model = RecipeListModel()
    
    enum State {
        case api
        case favorites
    }
    
    func searchTextSubmitted(_ text: String) async {
        guard model.state == .api else { return }
        
        model.searchText = text
        
        await getFirstPage()
    }
    
    private func getFirstPage() async {
        model.showError = false
        model.isLoading = true
        
        do {
            let response = try await AppEnvironment.current.recipeRepository.getRecipes(
                searchText: model.searchText,
                number: 10,
                offset: 0
            )
            
            model.recipes = response.results
            let count = response.totalResults
            model.totalResults = count
            model.resultsReceived = count < 10 ? count : 10
        } catch {
            model.showError = true
        }
        
        model.isLoading = false
    }
    
    func getNextPage() async {
        do {
            let response = try await AppEnvironment.current.recipeRepository.getRecipes(
                searchText: model.searchText,
                number: model.recipeRequestCount,
                offset: model.offset
            )
            
            let recipes = response.results
            model.recipes.append(contentsOf: recipes)
            model.resultsReceived += recipes.count
        } catch {
           // Show a toast
        }
    }
    
    func stateSelected(_ state: State) {
        model.state = state
    }
}

struct RecipeListModel {
    var recipes: [Recipe] = []
    var searchText = ""
    var isLoading = false
    var showError = false
    var state: RecipeListViewModel.State = .api
    
    // Paging
    var totalResults = 0
    var resultsReceived = 0
    var recipeRequestCount: Int {
        if remainingResults < 10 {
            return remainingResults
        } else {
            return 10
        }
    }
    var hasNextPage: Bool {
        remainingResults > 0
    }
    var remainingResults: Int {
        totalResults - resultsReceived
    }
    var offset: Int {
        resultsReceived
    }
}
