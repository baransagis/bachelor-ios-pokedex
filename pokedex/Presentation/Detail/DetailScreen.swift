import SwiftUI

struct DetailScreen: View {
    let id: Int

    var body: some View {
        VStack(spacing: 16) {
            Text("Detail Screen")
                .font(.title2)
            Text("Pokemon ID: \(id)")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .navigationTitle("Detail")
    }
}

#Preview {
    NavigationStack {
        DetailScreen(id: 1)
    }
}
