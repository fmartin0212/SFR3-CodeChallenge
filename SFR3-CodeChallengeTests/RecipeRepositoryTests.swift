//
//  RecipeRepositoryTests.swift
//  SFR3-CodeChallengeTests
//
//  Created by Frank Martin on 8/26/24.
//

import Foundation
@testable import SFR3_CodeChallenge
import XCTest

class RecipeRepositoryTests: BaseTestCase {
    /// Demonstrates that NetworkClient is testable
    func testGetRecipes() async {
        let json = """
{
        "offset": 0,
        "number": 2,
        "results": [
            {
                "id": 716429,
                "title": "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",
                "image": "https://img.spoonacular.com/recipes/716429-312x231.jpg",
                "imageType": "jpg",
            },
            {
                "id": 715538,
                "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
                "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
                "imageType": "jpg",
            }
        ],
        "totalResults": 86
    }
"""
        let data = json.data(using: .utf8)!
        
        urlSession.enqueueResponseForRequest(response: (data, .init()))
        
        let recipeResponse = try? await recipeRepository.getRecipes(searchText: "pasta", number: 1, offset: 2)
        let results = recipeResponse?.results
        XCTAssertEqual(results?.map(\.id), [716429, 715538])
    }
    
    /// Demonstrates that CoreData is testable
    func testAddFavorite() async {
        let detail = RecipeDetail(id: 123, title: "My recipe", image: nil, cookingMinutes: 25, instructions: "instructions", extendedIngredients: [.init(name: "broccoli", amount: 2.0, id: 456)])
        
        await recipeRepository.addFavorite(recipe: detail)
        
        let object = recipeRepository.storage.getObject(withType: FavoriteRecipe.self, identifier: 123)
        
        XCTAssertNotNil(object)
    }
}
