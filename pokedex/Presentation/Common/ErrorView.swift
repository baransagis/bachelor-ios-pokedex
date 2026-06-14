import SwiftUI

struct ErrorView: View {
    let onRetry: () async -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text("Das Laden der Daten ist fehlgeschlagen.")
                .font(PokedexTheme.Typography.body)
                .foregroundStyle(PokedexTheme.Colors.primaryText)
                .multilineTextAlignment(.center)

            Spacer()
                .frame(height: 16)

            Button {
                Task {
                    await onRetry()
                }
            } label: {
                Text("Erneut versuchen")
                    .font(PokedexTheme.Typography.body.weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 40)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .background(PokedexTheme.Colors.background)
    }
}

#Preview("Error light") {
    ErrorView {}
        .preferredColorScheme(.light)
}

#Preview("Error dark") {
    ErrorView {}
        .preferredColorScheme(.dark)
}
