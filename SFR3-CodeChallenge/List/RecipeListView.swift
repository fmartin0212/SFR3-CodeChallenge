//
//  RecipeListView.swift
//  SFR3-CodeChallenge
//
//  Created by Frank Martin on 8/26/24.
//

import Combine
import SwiftUI

@MainActor
struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        RecipeListViewContent(viewModel: viewModel, model: viewModel.model)
    }
}

@MainActor
struct RecipeListViewContent: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteRecipe.identifier, ascending: true)],
        animation: .default)
    private var favorites: FetchedResults<FavoriteRecipe>
    @State var searchText = ""
    
    let viewModel: RecipeListViewModel
    let model: RecipeListModel
    
    var body: some View {
        NavigationView {
            if model.isLoading {
                ProgressView()
            } else if model.showError {
                Text("Error")
            } else  {
                VStack(spacing: 16) {
                    picker
                    list
                }
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            Task {
                await viewModel.searchTextSubmitted(searchText)
            }
        }
    }
    
    private var picker: some View {
        Picker(NSLocalizedString("List Source", comment: ""), selection: Binding(get: {
            model.state
        }, set: {
            viewModel.stateSelected($0)
        })) {
            Text(NSLocalizedString("All", comment: "")).tag(RecipeListViewModel.State.api)
            Text(NSLocalizedString("Favorites", comment: "")).tag(RecipeListViewModel.State.favorites)
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    @ViewBuilder
    private var list: some View {
        if model.state == .api {
            recipes
        } else {
            favoritesList
        }
    }
    
    private var recipes: some View {
        List {
            ForEach(model.recipes, id: \.id) { recipe in
                NavigationLink {
                    RecipeDetailView(recipeID: recipe.id)
                } label: {
                    recipeRow(for: recipe)
                }
                .listRowSeparator(.hidden)
            }
            nextPageLoader
        }
        .navigationTitle(NSLocalizedString("All Recipes", comment: ""))
        .listStyle(.plain)
    }
    
    private var favoritesList: some View {
        List {
            ForEach(favorites, id: \.identifier) { favorite in
                favoriteRow(for: favorite)
            }
        }
        .navigationTitle(NSLocalizedString("Favorites", comment: ""))
        .listStyle(.plain)
    }
    
    private func recipeRow(for recipe: Recipe) -> some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: recipe.image)) { image in
                image
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                Image.named(.forkKnife)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Text(recipe.title)
            Spacer()
            favoriteIcon(for: recipe)
        }
        .padding()
        .cardified()
        .listRowSeparator(.hidden)
    }
    
    private func favoriteRow(for favorite: FavoriteRecipe) -> some View {
        HStack(spacing: 16) {
            if let data = favorite.image?.data {
                Image(uiImage: UIImage(data: data) ?? .named(.forkKnife))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image.named(.forkKnife)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Text(favorite.name ?? "")
            Spacer()
            Image.named(.heartFill)
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.red)
        }
        .padding()
        .cardified()
        .listRowSeparator(.hidden)
    }
    
    @ViewBuilder
    private func favoriteIcon(for recipe: Recipe) -> some View {
        if favorites.map(\.identifier).contains(recipe.id) {
            Spacer()
            Image.named(.heartFill)
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.red)
        }
    }
    
    @ViewBuilder
    private var nextPageLoader: some View {
        if model.hasNextPage {
            HStack {
                Spacer()
                ProgressView()
                    .frame(width: 20, height: 20)
                    .onAppear {
                        Task {
                            await viewModel.getNextPage()
                        }
                    }
                Spacer()
            }
            .listRowSeparator(.hidden)
        }
    }
}
