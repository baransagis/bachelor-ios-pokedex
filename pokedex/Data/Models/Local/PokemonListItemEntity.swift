import Foundation
import SwiftData

@Model
final class PokemonListItemEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var types: [String]

    init(id: Int, name: String, types: [String]) {
        self.id = id
        self.name = name
        self.types = types
    }
}

extension PokemonListItemEntity {
    convenience init(dto: PokemonListItemDTO) {
        self.init(id: dto.id, name: dto.name, types: dto.types)
    }

    func toDTO() -> PokemonListItemDTO {
        PokemonListItemDTO(id: id, name: name, types: types)
    }

    func update(with dto: PokemonListItemDTO) {
        name = dto.name
        types = dto.types
    }
}
