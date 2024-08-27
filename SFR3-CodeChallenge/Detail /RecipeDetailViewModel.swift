//
//  RecipeDetailViewModel.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import SwiftUI

@MainActor
class RecipeDetailViewModel: ObservableObject {
    @Published var model = RecipeDetailModel()
    
    func load(recipeID: Int64) async {
        model.isLoading = true
        model.showError = false
        
        model.isFavorite = retriveFromStorage(recipeID: recipeID) != nil
        do {
            let response = try await AppEnvironment.current.recipeRepository.getRecipeDetail(recipeID: recipeID)
            
            model.recipeDetails = response
        } catch {
            model.showError = true
        }
       
        model.isLoading = false
    }
    
    func favoriteButtonPressed() async {
        guard let recipeDetails = model.recipeDetails else { return }
        
        if model.isFavorite {
            try? AppEnvironment.current.recipeRepository.removeFavorite(recipeID: recipeDetails.id)
            model.isFavorite.toggle()
        } else {
            await AppEnvironment.current.recipeRepository.addFavorite(recipe: recipeDetails)
            model.isFavorite.toggle()
        }
    }
    
    private func retriveFromStorage(recipeID: Int64) -> FavoriteRecipe? {
        AppEnvironment.current.recipeRepository.getRecipeFromStorage(id: recipeID)
    }
}

struct RecipeDetailModel {
    var isLoading = false
    var showError = false
    var recipeDetails: RecipeDetail?
    var isFavorite = false
    var imageURL: String {
        recipeDetails?.image ?? ""
    }
    var ingredients: [RecipeIngredient] {
        recipeDetails?.extendedIngredients ?? []
    }
    var instructions: String {
        recipeDetails?.instructions ?? ""
    }
    var cookingMinutes: String {
        guard let minutes = recipeDetails?.cookingMinutes else { return "" }
        return "\(minutes) minutes"
    }
}

struct RecipeDetail: Decodable {
    let id: Int64
    let title: String?
    let image: String?
    let cookingMinutes: Int64?
    let instructions: String?
    let extendedIngredients: [RecipeIngredient]
}

struct RecipeIngredient: Decodable {
    let name: String
    let amount: Double
    let id: Int64
}

