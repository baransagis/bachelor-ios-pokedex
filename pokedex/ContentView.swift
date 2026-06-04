//
//  ContentView.swift
//  pokedex
//
//  Created by Baran Alexander Sagis on 27.05.26.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    let container: AppContainer

    var body: some View {
        NavigationStack {
            ListScreen(repository: container.pokedexRepository)
        }
    }
}

#Preview {
    let container = AppContainer.makeDefault()
    ContentView(container: container)
        .modelContainer(container.modelContainer)
}
