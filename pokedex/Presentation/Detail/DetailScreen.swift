import SwiftUI

struct DetailScreen: View {
    let id: Int
    @State private var viewModel: DetailViewModel

    init(id: Int, repository: PokedexRepository) {
        self.id = id
        _viewModel = State(initialValue: DetailViewModel(repository: repository))
    }

    var body: some View {
        ZStack {
            PokedexTheme.Colors.background
                .ignoresSafeArea()

            if viewModel.isError {
                ErrorView {
                    await viewModel.loadPokemonDetail(id: id)
                }
            } else if let pokemon = viewModel.pokemon {
                DetailContent(pokemon: pokemon)
            } else {
                ProgressView()
            }
        }
        .task(id: id) {
            await viewModel.loadPokemonDetail(id: id)
        }
        .navigationTitle(toolbarTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(PokedexTheme.Colors.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(toolbarTitle)
                    .font(PokedexTheme.Typography.toolbarTitle)
                    .foregroundStyle(PokedexTheme.Colors.primaryText)
            }
        }
    }

    private var toolbarTitle: String {
        if let pokemon = viewModel.pokemon {
            "\(pokemon.name) \(PokedexTheme.Format.pokemonNumber(id: pokemon.id))"
        } else {
            PokedexTheme.Format.pokemonNumber(id: id)
        }
    }
}

private struct DetailContent: View {
    let pokemon: PokemonDetailDTO

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 0) {
                PokemonHero(pokemon: pokemon)

                Spacer()
                    .frame(height: 8)

                TypeChips(types: pokemon.types)

                Spacer()
                    .frame(height: 32)

                Text(pokemon.description)
                    .font(PokedexTheme.Typography.detailBody)
                    .foregroundStyle(PokedexTheme.Colors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
                    .frame(height: 32)

                AttributeGrid(pokemon: pokemon)

                Spacer()
                    .frame(height: 32)

                AbilitiesSection(abilities: pokemon.abilities)

                Spacer()
                    .frame(height: 32)

                BaseStatsSection(baseStats: pokemon.baseStats)
            }
            .padding(16)
        }
        .background(PokedexTheme.Colors.background)
    }
}

private struct PokemonHero: View {
    let pokemon: PokemonDetailDTO

    var body: some View {
        ZStack {
            Image(PokedexTheme.Assets.detailBackground)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 248, height: 248)
                .accessibilityHidden(true)

            Image(PokedexTheme.Assets.pokemonSpriteName(for: pokemon.id))
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 248, height: 248)
                .accessibilityHidden(true)
        }
        .frame(width: 248, height: 248)
    }
}

private struct TypeChips: View {
    let types: [String]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(types, id: \.self) { type in
                Text(type.uppercased())
                    .font(PokedexTheme.Typography.typeChip)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(PokedexTheme.Colors.typeColor(for: type), in: Capsule())
            }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct AttributeGrid: View {
    let pokemon: PokemonDetailDTO

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                AttributeCard(label: "Größe", value: String(format: "%.1fm", pokemon.heightMeters))
                AttributeCard(label: "Gewicht", value: String(format: "%.1fkg", pokemon.weightKg))
            }

            AttributeCard(label: "Kategorie", value: pokemon.genus)
        }
    }
}

private struct AttributeCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Text(label.uppercased())
                .font(PokedexTheme.Typography.detailAttributeLabel)
                .foregroundStyle(PokedexTheme.Colors.secondaryText)

            Text(value)
                .font(PokedexTheme.Typography.detailAttributeValue)
                .foregroundStyle(PokedexTheme.Colors.primaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 82)
        .padding(16)
        .background(PokedexTheme.Colors.cardBackground, in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct AbilitiesSection: View {
    let abilities: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader("Fähigkeiten")

            if abilities.isEmpty {
                Text("Keine Fähigkeiten vorhanden")
                    .font(PokedexTheme.Typography.body)
                    .foregroundStyle(PokedexTheme.Colors.secondaryText)
            } else {
                FlowLayout(spacing: 4) {
                    ForEach(abilities, id: \.self) { ability in
                        Text(ability)
                            .font(PokedexTheme.Typography.abilityChip)
                            .foregroundStyle(PokedexTheme.Colors.primaryText)
                            .lineLimit(1)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(PokedexTheme.Colors.abilityChipBackground, in: Capsule())
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct BaseStatsSection: View {
    let baseStats: PokemonBaseStatsDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader("Artenspezifische Stärken")

            Spacer()
                .frame(height: 16)

            VStack(spacing: 16) {
                StatRow(label: "KP", value: baseStats.hp, stat: .hp)
                StatRow(label: "ANGRIFF", value: baseStats.attack, stat: .attack)
                StatRow(label: "VERTEIDIGUNG", value: baseStats.defense, stat: .defense)
                StatRow(label: "SPEZIAL-ANGRIFF", value: baseStats.specialAttack, stat: .specialAttack)
                StatRow(label: "SPEZIAL-VERTEIDIGUNG", value: baseStats.specialDefense, stat: .specialDefense)
                StatRow(label: "INITIATIVE", value: baseStats.speed, stat: .speed)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct StatRow: View {
    let label: String
    let value: Int
    let stat: Stat

    private var progress: CGFloat {
        min(max(CGFloat(value) / 255, 0), 1)
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(label)
                    .font(PokedexTheme.Typography.statLabel)
                    .foregroundStyle(PokedexTheme.Colors.secondaryText)

                Spacer()

                Text(value.description)
                    .font(PokedexTheme.Typography.statLabel)
                    .foregroundStyle(PokedexTheme.Colors.primaryText)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(PokedexTheme.Colors.statTrack)

                    Capsule()
                        .fill(PokedexTheme.Colors.statColor(stat))
                        .frame(width: proxy.size.width * progress)
                }
            }
            .frame(height: 4)
        }
    }
}

private struct SectionHeader: View {
    let label: String

    init(_ label: String) {
        self.label = label
    }

    var body: some View {
        Text(label)
            .font(PokedexTheme.Typography.detailSectionTitle)
            .foregroundStyle(PokedexTheme.Colors.primaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct FlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 0
        return layout(in: maxWidth, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(in: bounds.width, subviews: subviews)
        let rowOffset = (bounds.height - result.size.height) / 2

        for item in result.items {
            subviews[item.index].place(
                at: CGPoint(x: bounds.minX + item.origin.x, y: bounds.minY + rowOffset + item.origin.y),
                proposal: ProposedViewSize(item.size)
            )
        }
    }

    private func layout(in maxWidth: CGFloat, subviews: Subviews) -> (size: CGSize, items: [Item]) {
        var items: [Item] = []
        var row: [PendingItem] = []
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0
        var y: CGFloat = 0
        var measuredWidth: CGFloat = 0

        func flushRow() {
            guard !row.isEmpty else {
                return
            }

            let xOffset = max((maxWidth - rowWidth) / 2, 0)
            var x: CGFloat = xOffset

            for pendingItem in row {
                items.append(Item(index: pendingItem.index, origin: CGPoint(x: x, y: y), size: pendingItem.size))
                x += pendingItem.size.width + spacing
            }

            measuredWidth = max(measuredWidth, rowWidth)
            y += rowHeight + spacing
            row.removeAll()
            rowWidth = 0
            rowHeight = 0
        }

        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let nextWidth = row.isEmpty ? size.width : rowWidth + spacing + size.width

            if !row.isEmpty && maxWidth > 0 && nextWidth > maxWidth {
                flushRow()
            }

            row.append(PendingItem(index: index, size: size))
            rowWidth = row.isEmpty ? size.width : (rowWidth == 0 ? size.width : rowWidth + spacing + size.width)
            rowHeight = max(rowHeight, size.height)
        }

        flushRow()

        return (CGSize(width: maxWidth > 0 ? maxWidth : measuredWidth, height: max(y - spacing, 0)), items)
    }

    private struct PendingItem {
        let index: Int
        let size: CGSize
    }

    private struct Item {
        let index: Int
        let origin: CGPoint
        let size: CGSize
    }
}

#Preview {
    NavigationStack {
        DetailContent(
            pokemon: PokemonDetailDTO(
                id: 1,
                name: "Bisasam",
                types: ["Pflanze", "Gift"],
                heightDm: 7,
                weightHg: 69,
                heightMeters: 0.7,
                weightKg: 6.9,
                abilities: ["Notdünger", "Chlorophyll"],
                baseStats: PokemonBaseStatsDTO(
                    hp: 45,
                    attack: 49,
                    defense: 49,
                    specialAttack: 65,
                    specialDefense: 65,
                    speed: 45
                ),
                genus: "Samen-Pokémon",
                description: "Dieses Pokémon trägt von Geburt an einen Samen auf dem Rücken, der mit ihm keimt und wächst.",
                color: "green",
                habitat: "grassland"
            )
        )
        .navigationTitle("Bisasam #001")
    }
    .preferredColorScheme(.dark)
}
