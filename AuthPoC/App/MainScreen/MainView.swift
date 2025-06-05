import SwiftUI

struct MainView: View {
  var authService: any AuthServicing
  @State private var logoutError: String?

  var body: some View {
    NavigationStack {
      ZStack {
        LinearGradient(
          colors: [Color.blue.opacity(0.1), Color.white],
          startPoint: .topLeading,
          endPoint: .bottomTrailing,
        )
        .ignoresSafeArea()

        VStack(spacing: 24) {
          Text("Welcome to the App")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 40)

          NavigationLink(
            destination: JWTClaimsView(
              viewModel: JWTViewModel(token: authService.accessToken),
            ),
          ) {
            Text("Decode JWT Token")
              .font(.headline)
              .foregroundColor(.orange)
              .padding()
              .frame(width: 250, height: 60)
              // .background(Color.orange)
              .cornerRadius(12)
              .padding(.horizontal)
          }

          WideButton {
            Task {
              let controller = KeyWindow.controller ?? .init()
              let result = await authService.logOut(from: controller)
              if case let .failure(error) = result {
                logoutError = error.localizedDescription
              } else {
                logoutError = nil
              }
            }
          } title: {
            Text("Log Out")
          }

          if let message = logoutError {
            Text(message)
              .foregroundColor(.red)
              .font(.caption)
              .padding(.horizontal)
          }

          Spacer()
        }
        .navigationTitle("Main")
      }
    }
  }
}

#Preview {
  MainView(authService: AuthService())
}
