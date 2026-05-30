import SwiftUI

struct ListScreen: View {
    var body: some View {
        List {
            Section("Pokemon") {
                NavigationLink("Open detail for #1", value: 1)
                NavigationLink("Open detail for #25", value: 25)
            }
        }
        .navigationTitle("Pokedex")
        .navigationDestination(for: Int.self) { id in
            DetailScreen(id: id)
        }
    }
}

#Preview {
    NavigationStack {
        ListScreen()
    }
}
