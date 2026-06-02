//
//  ContentView.swift
//  pokedex
//
//  Created by Baran Alexander Sagis on 27.05.26.
//

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
    ContentView(container: .makeDefault())
}
