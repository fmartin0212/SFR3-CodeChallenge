//
//  AppEnvironment.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import Foundation

class AppEnvironment {
    let recipeRepository: RecipeRepositoryType
    let networkClient: NetworkClientType
    
    private(set) static var current = AppEnvironment()
    
    init(
        recipeRepository: RecipeRepositoryType = RecipeRepository(),
        networkClient: NetworkClientType = NetworkClient()
    ) {
        self.recipeRepository = recipeRepository
        self.networkClient = networkClient
    }
    
    func change(environment: AppEnvironment) {
        Self.current = environment
    }
}

