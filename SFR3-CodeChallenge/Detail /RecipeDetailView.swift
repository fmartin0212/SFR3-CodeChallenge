//
//  RecipeDetailView.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import SwiftUI

struct RecipeDetailView: View {
    @StateObject private var viewModel = RecipeDetailViewModel()
    private let recipeID: Int64
    
    init(recipeID: Int64) {
        self.recipeID = recipeID
    }
    
    var body: some View {
        RecipeDetailContentView(viewModel: viewModel, model: viewModel.model)
            .task {
                await viewModel.load(recipeID: recipeID)
            }
    }
}

@MainActor
struct RecipeDetailContentView: View {
    let viewModel: RecipeDetailViewModel
    let model: RecipeDetailModel
    
    var body: some View {
        content
            .navigationTitle(model.recipeDetails?.title ?? "")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    var content: some View {
        if model.isLoading {
            ProgressView()
        } else if model.showError {
            Text("Error")
        } else {
            details
        }
    }
    
    var details: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    image(width: proxy.size.width)
                    VStack(alignment: .leading, spacing: 36) {
                        favoriteButton
                        ingredients
                        cookingTime
                        instructions
                    }
                    .padding()
                }
            }
        }
    }
    
    func image(width: Double) -> some View {
        AsyncImage(url: URL(string: model.imageURL), content: { image in
            image
                .resizable()
                .frame(width: width, height: 200)
                .aspectRatio(contentMode: .fit)
        }, placeholder: {
            Image.named(.forkKnife)
                .frame(width: 200, height: 200) // Would use a better placeholder IRL
        })
    }
    
    var favoriteButton: some View {
        HStack {
            Spacer()
            Button {
                Task {
                    await viewModel.favoriteButtonPressed()
                }
            } label: {
                if model.isFavorite {
                    Image.named(.heartFill)
                        .foregroundStyle(Color.red)
                } else {
                    Image.named(.heart)
                        .foregroundStyle(Color.gray)
                }
            }
            
        }
    }
    
    var ingredients: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(NSLocalizedString("Ingredients", comment: ""))
                .font(.title2)
            ForEach(model.ingredients, id: \.id) { ingredient in
                HStack {
                    Text(ingredient.name)
                    Spacer()
                    Text("\(ingredient.amount)")
                }
            }
        }
    }
    
    @ViewBuilder
    var cookingTime: some View {
        if !model.cookingMinutes.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(NSLocalizedString("Cook time", comment: ""))
                    .font(.title2)
                Text(model.cookingMinutes)
            }
        }
    }
    
    var instructions: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(NSLocalizedString("Instructions", comment: ""))
                .font(.title2)
            Text(model.instructions)
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var detail: RecipeDetailModel {
        var detail = RecipeDetailModel()
        detail.recipeDetails = .init(id: 1, title: "Recipe name", image: "", cookingMinutes: 25, instructions: "instructions", extendedIngredients: [
            .init(name: "Ingredient 1", amount: 0.5, id: 1),
            .init(name: "Ingredient 2", amount: 1.5, id: 2)
        ]
        )
        detail.isFavorite = true
        return detail
    }
    
    static var previews: some View {
        RecipeDetailContentView(viewModel: .init(), model: detail)
    }
}
