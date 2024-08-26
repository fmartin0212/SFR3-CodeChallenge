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

