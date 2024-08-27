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
                ErrorView {
                    Task {
                        await viewModel.searchTextSubmitted(searchText)
                    }
                }
            } else  {
                VStack(spacing: 16) {
                    picker
                    list
                }
            }
        }
        .searchable(text: $searchText)
        .disabled(model.showError) // for lack of better solution. would probably roll my own search bar for more control over when it is visible
        .onSubmit(of: .search) {
            Task {
                await viewModel.searchTextSubmitted(searchText) // Would implement a debounce in production for a best user experience
            }
        }
    }
    
    private var picker: some View {
        Picker(NSLocalizedString("List Source", comment: ""), selection: Binding(
            get: {
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

struct RecipeListView_Previews: PreviewProvider {
    static var list: RecipeListModel {
        var model = RecipeListModel()
        model.recipes = [
            .init(id: 1, title: "burger", image: ""),
            .init(id: 2, title: "fries", image: ""),
            .init(id: 3, title: "milkshake", image: "")
        ]
        return model
    }
    static var error: RecipeListModel {
        var model = RecipeListModel()
        model.showError = true
        return model
    }
    static var previews: some View {
        RecipeListViewContent(viewModel: .init(), model: list)
        RecipeListViewContent(viewModel: .init(), model: error)
    }
}
