//
//  RecipeDetail.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import Foundation

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
