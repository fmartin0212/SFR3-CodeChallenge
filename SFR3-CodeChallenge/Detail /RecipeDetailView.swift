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
        content
            .task {
                await viewModel.load(recipeID: recipeID)
            }
            .navigationTitle(viewModel.model.recipeDetails?.title ?? "")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.model.isLoading {
            ProgressView()
        } else if viewModel.model.showError {
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
                    VStack(alignment: .leading, spacing: 16) {
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
        AsyncImage(url: URL(string: viewModel.model.imageURL), content: { image in
            image
                .resizable()
                .frame(width: width, height: 200)
                .aspectRatio(contentMode: .fit)
        }, placeholder: {
            Image.named(.heart)
                .frame(width: 200, height: 200)
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
                if viewModel.model.isFavorite {
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
        VStack {
            ForEach(viewModel.model.ingredients, id: \.id) { ingredient in
                HStack {
                    Text(ingredient.name)
                    Spacer()
                    Text("\(ingredient.amount)")
                }
            }
        }
    }
    
    var cookingTime: some View {
        Text(viewModel.model.cookingMinutes)
    }
    
    var instructions: some View {
        Text(viewModel.model.instructions)
    }
}

@MainActor
class RecipeDetailViewModel: ObservableObject {
    @Published var model = RecipeDetailModel()
    
    func load(recipeID: Int64) async {
        model.isLoading = true
        model.showError = false
        
        model.isFavorite = retriveFromStorage(recipeID: recipeID) != nil
        do {
            let response = try await AppEnvironment.current.recipeRepository.getRecipeDetail(recipeID: recipeID)
            
            model.recipeDetails = response
        } catch {
            model.showError = true
        }
       
        model.isLoading = false
    }
    
    func favoriteButtonPressed() async {
        guard let recipeDetails = model.recipeDetails else { return }
        
        if model.isFavorite {
            try? AppEnvironment.current.recipeRepository.removeFavorite(recipeID: recipeDetails.id)
            model.isFavorite.toggle()
        } else {
            await AppEnvironment.current.recipeRepository.addFavorite(recipe: recipeDetails)
            model.isFavorite.toggle()
        }
    }
    
    private func retriveFromStorage(recipeID: Int64) -> FavoriteRecipe? {
        AppEnvironment.current.recipeRepository.getRecipeFromStorage(id: recipeID)
    }
}

struct RecipeDetailModel {
    var isLoading = false
    var showError = false
    var recipeDetails: RecipeDetail?
    var isFavorite = false
    var imageURL: String {
        recipeDetails?.image ?? ""
    }
    var ingredients: [RecipeIngredient] {
        recipeDetails?.extendedIngredients ?? []
    }
    var instructions: String {
        recipeDetails?.instructions ?? ""
    }
    var cookingMinutes: String {
        guard let minutes = recipeDetails?.cookingMinutes else { return "" }
        return "\(minutes) minutes"
    }
}

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

