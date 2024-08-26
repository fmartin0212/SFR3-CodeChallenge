//
//  TestLocalStorage.swift
//  SFR3-CodeChallengeTests
//
//  Created by Frank Martin on 8/26/24.
//

import CoreData
@testable import SFR3_CodeChallenge

class TestLocalStorage: LocalStorageType {
    let store: PersistenceController
    var context: NSManagedObjectContext
    
    init(store: PersistenceController) {
        self.store = store
        self.context = store.container.viewContext
    }
}
