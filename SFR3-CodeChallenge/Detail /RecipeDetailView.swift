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
