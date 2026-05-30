//
//  pokedexApp.swift
//  pokedex
//
//  Created by Baran Alexander Sagis on 27.05.26.
//

import SwiftUI

@main
struct pokedexApp: App {
    private let container = AppContainer.makeDefault()

    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
    }
}
