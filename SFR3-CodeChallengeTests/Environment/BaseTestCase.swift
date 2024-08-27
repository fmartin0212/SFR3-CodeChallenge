//
//  BaseTestCase.swift
//  SFR3-CodeChallengeTests
//
//  Created by Frank Martin on 8/26/24.
//

@testable import SFR3_CodeChallenge
import XCTest

class BaseTestCase: XCTestCase {
    let storage = LocalStorage(store: .preview)
    let urlSession = TestURLSession()
    lazy var recipeRepository = {
        TestRecipeRepository(storage: storage)
    }()
    lazy var networkClient = {
        TestNetworkClient(urlSession: urlSession)
    }()
 
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let testEnv = AppEnvironment(
            recipeRepository: recipeRepository,
            networkClient: networkClient
        )
        
        AppEnvironment.current.change(environment: testEnv)
    }
}

let testRecipesJSON = """
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
    },
    {
        "id": 715539,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 715531,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 715532,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 715533,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 715534,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 715535,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 715536,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 715537,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg"
}
],
"totalResults": 16
}
"""

let testRecipesSecondPageJSON = """
{
"offset": 0,
"number": 2,
"results": [
    {
        "id": 1,
        "title": "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",
        "image": "https://img.spoonacular.com/recipes/716429-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 2,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 3,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 4,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 5,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    },
    {
        "id": 6,
        "title": "What to make for dinner tonight?? Bruschetta Style Pork & Pasta",
        "image": "https://img.spoonacular.com/recipes/715538-312x231.jpg",
        "imageType": "jpg",
    }
],
"totalResults": 16
}
"""
