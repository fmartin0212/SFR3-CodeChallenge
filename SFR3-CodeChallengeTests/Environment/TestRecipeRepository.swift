//
//  TestRecipeRepository.swift
//  SFR3-CodeChallengeTests
//
//  Created by Frank Martin on 8/26/24.
//

@testable import SFR3_CodeChallenge
import XCTest

class TestRecipeRepository: RecipeRepositoryType {
    var storage: LocalStorageType
    var baseURL: URL = URL(string: "www.google.com")!
    
    init(storage: LocalStorageType) {
        self.storage = storage
    }
}


