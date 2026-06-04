import CoreText
import SwiftUI

enum PokedexTheme {
    enum Colors {
        static let background = Color("background")
        static let divider = Color("divider")
        static let primaryText = Color("primaryText")
        static let secondaryText = Color("secondaryText")
        static let cardBackground = Color("cardBackground")
        static let abilityChipBackground = cardBackground
        static let statTrack = Color("statTrack")

        static func statColor(_ stat: Stat) -> Color {
            switch stat {
            case .hp:
                Color(hex: 0xEF5350)
            case .attack:
                Color(hex: 0xFFA726)
            case .defense:
                Color(hex: 0xFFD54F)
            case .specialAttack:
                Color(hex: 0x42A5F5)
            case .specialDefense:
                Color(hex: 0x66BB6A)
            case .speed:
                Color(hex: 0xAB47BC)
            }
        }

        static func typeColor(for type: String) -> Color {
            switch type.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
            case "normal":
                Color(hex: 0xA8A77A)
            case "feuer":
                Color(hex: 0xEE8130)
            case "wasser":
                Color(hex: 0x6390F0)
            case "elektro":
                Color(hex: 0xF7D02C)
            case "pflanze":
                Color(hex: 0x7AC74C)
            case "eis":
                Color(hex: 0x96D9D6)
            case "kampf":
                Color(hex: 0xC22E28)
            case "gift":
                Color(hex: 0xA33EA1)
            case "boden":
                Color(hex: 0xE2BF65)
            case "flug":
                Color(hex: 0xA98FF3)
            case "psycho":
                Color(hex: 0xF95587)
            case "kafer", "kaefer", "käfer":
                Color(hex: 0xA6B91A)
            case "gestein":
                Color(hex: 0xB6A136)
            case "geist":
                Color(hex: 0x735797)
            case "drache":
                Color(hex: 0x6F35FC)
            case "unlicht":
                Color(hex: 0x705746)
            case "stahl":
                Color(hex: 0xB7B7CE)
            case "fee":
                Color(hex: 0xD685AD)
            default:
                secondaryText
            }
        }
    }

    enum Typography {
        static let body = Font.custom("Inter", size: 16, relativeTo: .body)
        static let toolbarTitle = Font.custom("Inter", size: 17, relativeTo: .headline).weight(.semibold)
        static let listNumber = Font.custom("Inter", size: 24, relativeTo: .title2).weight(.semibold)
        static let listTitle = Font.custom("Inter", size: 20, relativeTo: .title3).weight(.semibold)
        static let typeChip = Font.custom("Inter", size: 14, relativeTo: .subheadline).weight(.semibold)
        static let detailBody = Font.custom("Inter", size: 16, relativeTo: .body)
        static let detailSectionTitle = Font.custom("Inter", size: 20, relativeTo: .title3).weight(.semibold)
        static let detailAttributeLabel = Font.custom("Inter", size: 16, relativeTo: .headline).weight(.semibold)
        static let detailAttributeValue = Font.custom("Inter", size: 20, relativeTo: .title3).weight(.semibold)
        static let abilityChip = Font.custom("Inter", size: 16, relativeTo: .headline).weight(.semibold)
        static let statLabel = Font.custom("Inter", size: 14, relativeTo: .subheadline).weight(.semibold)
    }

    enum Assets {
        static let detailBackground = "detail_background"

        static func pokemonSpriteName(for id: Int) -> String {
            "pokemon_\(id)"
        }
    }

    enum Format {
        static func pokemonNumber(id: Int) -> String {
            switch id {
            case ..<10:
                "#00\(id)"
            case ..<100:
                "#0\(id)"
            default:
                "#\(id)"
            }
        }
    }
}

enum Stat {
    case hp
    case attack
    case defense
    case specialAttack
    case specialDefense
    case speed
}

enum PokedexFontRegistrar {
    static func registerFonts() {
        guard let fontURLs = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil) else {
            return
        }

        for fontURL in fontURLs where fontURL.lastPathComponent.hasPrefix("Inter-") {
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }
}

private extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
