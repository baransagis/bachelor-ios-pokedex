import SwiftUI

struct DetailScreen: View {
    let id: Int
    @StateObject private var viewModel: DetailViewModel

    init(id: Int, repository: PokedexRepository) {
        self.id = id
        _viewModel = StateObject(wrappedValue: DetailViewModel(repository: repository))
    }

    var body: some View {
        List {
            Section("Detail test") {
                Text("Pokemon ID: \(id)")
                    .font(.headline)
            }

            Section("Detail networking") {
                Button("Load detail JSON") {
                    Task {
                        await viewModel.loadPokemonDetail(id: id)
                    }
                }

                if viewModel.isLoading {
                    ProgressView()
                }

                if let errorText = viewModel.errorText {
                    Text(errorText)
                        .foregroundStyle(.red)
                        .textSelection(.enabled)
                }

                Text(viewModel.jsonText)
                    .font(.system(.footnote, design: .monospaced))
                    .textSelection(.enabled)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Detail")
                    .font(.headline)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailScreen(id: 1, repository: PokedexRepositoryImpl(api: PokedexAPIClient()))
    }
}
