//
//  SFR3_CodeChallengeApp.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import SwiftUI

@main
struct SFR3_CodeChallengeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RecipeListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
