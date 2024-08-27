//
//  RecipeRepository.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import Foundation

protocol RecipeRepositoryType {
    var storage: LocalStorageType { get }
    var baseURL: URL { get }
    func getRecipes(searchText: String, number: Int, offset: Int) async throws -> RecipeResponse
    func getRecipeDetail(recipeID: Int64) async throws -> RecipeDetail
    func addFavorite(recipe: RecipeDetail) async
    func getRecipeFromStorage(id: Int64) -> FavoriteRecipe?
    func removeFavorite(recipeID: Int64) throws
}

class RecipeRepository: RecipeRepositoryType {
    let baseURL = URL(string: "https://api.spoonacular.com/recipes")!
    let storage: LocalStorageType
    
    init() {
        self.storage = LocalStorage(store: .shared)
    }
}

extension RecipeRepositoryType {
    func getRecipes(searchText: String, number: Int, offset: Int) async throws -> RecipeResponse {
        guard let url = searchURL(
            searchText: searchText.lowercased(),
            number: number,
            offset: offset
        ) else {
            throw RecipeRepositoryError.generic
        }
      
        let request = URLRequest(url: url)
        
        do {
            let data = try await AppEnvironment.current.networkClient.data(for: request)
            let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return response
        } catch {
            throw RecipeRepositoryError.getRecipes
        }
    }
    
    func getRecipeDetail(recipeID: Int64) async throws -> RecipeDetail {
        guard let url = detailURL(id: recipeID) else {
            throw RecipeRepositoryError.generic
        }
      
        let request = URLRequest(url: url)
        
        do {
            let data = try await AppEnvironment.current.networkClient.data(for: request)
            let response = try JSONDecoder().decode(RecipeDetail.self, from: data)
            return response
        } catch {
            throw RecipeRepositoryError.getRecipes
        }
    }
    
    func addFavorite(recipe: RecipeDetail) async {
        let object = FavoriteRecipe(context: storage.context)
        object.name = recipe.title
        object.identifier = recipe.id
        object.cookingMinutes = recipe.cookingMinutes ?? 0
        
        let image = FavoriteImage(context: storage.context)
        image.data = try? await AppEnvironment.current.networkClient.data(from: recipe.image ?? "")
        object.image = image
    
        recipe.extendedIngredients.forEach {
            let ingredient = Ingredient(context: storage.context)
            ingredient.identifier = $0.id
            ingredient.amount = $0.amount
            ingredient.name = $0.name
            object.addToIngredients(ingredient)
        }
       
        storage.save()
    }
    
    func getRecipeFromStorage(id: Int64) -> FavoriteRecipe? {
        storage.getObject(withType: FavoriteRecipe.self, identifier: id)
    }
    
    func removeFavorite(recipeID: Int64) throws {
        guard let favorite = storage.getObject(withType: FavoriteRecipe.self, identifier: recipeID) else {
            throw RecipeRepositoryError.generic
        }
        
        storage.delete(object: favorite)
    }
    
    private func searchURL(searchText: String, number: Int, offset: Int) -> URL? {
        var url = baseURL
        url.appendPathComponent("complexSearch")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let apiKey = URLQueryItem(name: "apiKey", value: "27e1403c2375499aa9150aeca1b750d7")
        let search = URLQueryItem(name: "query", value: searchText)
        let number = URLQueryItem(name: "number", value: "\(number)")
        let offset = URLQueryItem(name: "offset", value: "\(offset)")
        
        components?.queryItems = [apiKey, search, number, offset]
        return components?.url
    }
    
    private func detailURL(id: Int64) -> URL? {
        var url = baseURL
        url.appendPathComponent("\(id)")
        url.appendPathComponent("information")
        
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let apiKey = URLQueryItem(name: "apiKey", value: "27e1403c2375499aa9150aeca1b750d7")
        
        components?.queryItems = [apiKey]
        return components?.url
    }
}

enum RecipeRepositoryError: Error {
    case generic
    case getRecipes
}

struct RecipeResponse: Decodable {
    let results: [Recipe]
    let totalResults: Int
}

struct Recipe: Decodable {
    let id: Int64
    let title: String
    let image: String
}


