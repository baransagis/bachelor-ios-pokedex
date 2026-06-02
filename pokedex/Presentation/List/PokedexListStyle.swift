import SwiftUI

enum PokedexListStyle {
    static func background(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: 0x111415) : Color(hex: 0xF8F9FA)
    }

    static func divider(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: 0x333637) : Color(hex: 0xE5E7EB)
    }

    static func primaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: 0xE1E3E4) : Color(hex: 0x191C1D)
    }

    static func secondaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: 0xC6C6CD) : Color(hex: 0x45464C)
    }

    static func spriteName(for id: Int) -> String {
        "pokemon_\(id)"
    }

    static func numberText(for id: Int) -> String {
        switch id {
        case ..<10:
            "#00\(id)"
        case ..<100:
            "#0\(id)"
        default:
            "#\(id)"
        }
    }

    static func typeColor(for type: String, colorScheme: ColorScheme) -> Color {
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
            secondaryText(for: colorScheme)
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
