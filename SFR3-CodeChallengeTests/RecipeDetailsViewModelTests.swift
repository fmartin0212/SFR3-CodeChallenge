//
//  RecipeDetailsViewModelTests.swift
//  SFR3-CodeChallengeTests
//
//  Created by Frank Martin on 8/26/24.
//

@testable import SFR3_CodeChallenge
import XCTest

class RecipeDetailsViewModelTests: BaseTestCase {
    @MainActor
    let vm = RecipeDetailViewModel()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Clean up
        let object = storage.getObject(withType: FavoriteRecipe.self, identifier: 1)
        storage.delete(object: object ?? .init())
    }
    
    @MainActor
    func testLoad() async {
        let data = recipeDetailsJSON.data(using: .utf8)!
        urlSession.enqueueResponseForRequest(response: (data, .init()))

        await vm.load(recipeID: 1)
        
        XCTAssertNotNil(vm.model.recipeDetails)
        XCTAssertFalse(vm.model.isLoading)
        XCTAssertFalse(vm.model.showError)
        XCTAssertEqual(vm.model.imageURL, "https://img.spoonacular.com/recipes/716429-556x370.jpg")
        XCTAssertEqual(vm.model.isFavorite, false)
        XCTAssertEqual(vm.model.instructions, "some instructions")
        XCTAssertEqual(vm.model.ingredients.map(\.id), [1, 2])
        
    }
    
    @MainActor
    func testIsFavorite() async {
        let data = recipeDetailsJSON.data(using: .utf8)!
        urlSession.enqueueResponseForRequest(response: (data, .init()))
        
        let favorite = FavoriteRecipe(context: storage.context)
        favorite.identifier = 1
        storage.save()

        await vm.load(recipeID: 1)
        
        XCTAssertEqual(vm.model.isFavorite, true)

        await vm.favoriteButtonPressed()
        
        XCTAssertFalse(vm.model.isFavorite)
    }
}

let recipeDetailsJSON = """
{
    "id": 716429,
    "title": "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",
    "image": "https://img.spoonacular.com/recipes/716429-556x370.jpg",
    "imageType": "jpg",
    "servings": 2,
    "readyInMinutes": 45,
    "cookingMinutes": 25,
    "preparationMinutes": 20,
    "license": "CC BY-SA 3.0",
    "sourceName": "Full Belly Sisters",
    "sourceUrl": "http://fullbellysisters.blogspot.com/2012/06/pasta-with-garlic-scallions-cauliflower.html",
    "spoonacularSourceUrl": "https://spoonacular.com/pasta-with-garlic-scallions-cauliflower-breadcrumbs-716429",
    "healthScore": 19.0,
    "spoonacularScore": 83.0,
    "pricePerServing": 163.15,
    "analyzedInstructions": [],
    "cheap": false,
    "creditsText": "Full Belly Sisters",
    "cuisines": [],
    "dairyFree": false,
    "diets": [],
    "gaps": "no",
    "glutenFree": false,
    "instructions": "some instructions",
    "ketogenic": false,
    "lowFodmap": false,
    "occasions": [],
    "sustainable": false,
    "vegan": false,
    "vegetarian": false,
    "veryHealthy": false,
    "veryPopular": false,
    "whole30": false,
    "weightWatcherSmartPoints": 17,
    "dishTypes": [
        "lunch",
        "main course",
        "main dish",
        "dinner"
    ],
    "extendedIngredients": [
        {
            "aisle": "Milk, Eggs, Other Dairy",
            "amount": 1.0,
            "consistency": "solid",
            "id": 1,
            "image": "butter-sliced.jpg",
            "measures": {
                "metric": {
                    "amount": 1.0,
                    "unitLong": "Tbsp",
                    "unitShort": "Tbsp"
                },
                "us": {
                    "amount": 1.0,
                    "unitLong": "Tbsp",
                    "unitShort": "Tbsp"
                }
            },
            "meta": [],
            "name": "butter",
            "original": "1 tbsp butter",
            "originalName": "butter",
            "unit": "tbsp"
        },
        {
            "aisle": "Milk, Eggs, Other Dairy",
            "amount": 1.0,
            "consistency": "solid",
            "id": 2,
            "image": "butter-sliced.jpg",
            "measures": {
                "metric": {
                    "amount": 1.0,
                    "unitLong": "Tbsp",
                    "unitShort": "Tbsp"
                },
                "us": {
                    "amount": 1.0,
                    "unitLong": "Tbsp",
                    "unitShort": "Tbsp"
                }
            },
            "meta": [],
            "name": "butter",
            "original": "1 tbsp butter",
            "originalName": "butter",
            "unit": "tbsp"
        }
    ],
    "winePairing": {
        "pairedWines": [
            "chardonnay",
            "gruener veltliner",
            "sauvignon blanc"
        ],
        "pairingText": "Chardonnay, Gruener Veltliner, and Sauvignon Blanc are great choices for Pasta. Sauvignon Blanc and Gruner Veltliner both have herby notes that complement salads with enough acid to match tart vinaigrettes, while a Chardonnay can be a good pick for creamy salad dressings. The Buddha Kat Winery Chardonnay with a 4 out of 5 star rating seems like a good match. It costs about 25 dollars per bottle.",
        "productMatches": [
            {
                "id": 469199,
                "title": "Buddha Kat Winery Chardonnay",
                "description": "We barrel ferment our Chardonnay and age it in a mix of Oak and Stainless. Giving this light bodied wine modest oak character, a delicate floral aroma, and a warming finish.",
                "price": "$25.0",
                "imageUrl": "https://img.spoonacular.com/products/469199-312x231.jpg",
                "averageRating": 0.8,
                "ratingCount": 1.0,
                "score": 0.55,
                "link": "https://www.amazon.com/2015-Buddha-Kat-Winery-Chardonnay/dp/B00OSAVVM4?tag=spoonacular-20"
            }
        ]
    }
}
"""
