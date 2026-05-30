import SwiftUI

struct ListScreen: View {
    private let repository: PokedexRepository
    @StateObject private var viewModel: ListViewModel

    init(repository: PokedexRepository) {
        self.repository = repository
        _viewModel = StateObject(wrappedValue: ListViewModel(repository: repository))
    }

    var body: some View {
        List {
            Section("Navigation test") {
                NavigationLink("Open detail for #1", value: 1)
                NavigationLink("Open detail for #25", value: 25)
            }

            Section("List networking") {
                Button("Load list JSON") {
                    Task {
                        await viewModel.loadPokemon()
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
        .navigationTitle("Pokedex")
        .navigationDestination(for: Int.self) { id in
            DetailScreen(id: id, repository: repository)
        }
    }
}

#Preview {
    NavigationStack {
        ListScreen(repository: PokedexRepositoryImpl(api: PokedexAPIClient()))
    }
}
