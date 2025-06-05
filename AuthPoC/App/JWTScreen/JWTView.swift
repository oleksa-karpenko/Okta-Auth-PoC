import SwiftUI

struct JWTClaimsView: View {
  @StateObject var viewModel: JWTViewModel

  var body: some View {
    NavigationStack {
      ZStack {
        LinearGradient(
          colors: [Color.white, Color.blue.opacity(0.1)],
          startPoint: .top,
          endPoint: .bottom,
        )
        .ignoresSafeArea()

        VStack(alignment: .leading, spacing: 16) {
          TextField("Current JWT", text: $viewModel.token)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            .padding(.horizontal)

          WideButton {
            viewModel.decodeToken()
          } title: {
            Text("Decode Token")
          }

          if !viewModel.claims.isEmpty {
            Text("Decoded Claims")
              .font(.title2)
              .fontWeight(.medium)
              .padding(.horizontal)

            List {
              ForEach(
                viewModel.claims.sorted(
                  by: { $0.key < $1.key }),
                id: \.key,
              ) { key, value in
                VStack(alignment: .leading, spacing: 4) {
                  Text(key)
                    .font(.headline)
                    .fontWeight(.bold)
                  Text(value)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
                }
                .padding(.vertical, 4)
              }
            }
            .listStyle(.plain)
          }

          Spacer()
        }
        .padding(.top)
      }
      .navigationTitle("JWT Claims")
    }
    .task {
      viewModel.decodeToken()
    }
  }
}
