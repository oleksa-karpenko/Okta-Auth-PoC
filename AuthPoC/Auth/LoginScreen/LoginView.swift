import SwiftUI

struct LoginView<Model: LoginModel>: View {
  @StateObject private var viewModel: Model

  init(viewModel: Model) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      Image(systemName: "lock.shield")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 100, height: 100)
        .foregroundColor(.blue)
      Text("Okta Authorization Code Flow")
        .font(.system(size: 36))
        .bold()
      Spacer()
      if viewModel.isLoading {
        ProgressView()
          .progressViewStyle(.circular)
          .frame(height: 60)
      } else {
        WideButton {
          Task {
            await viewModel.startFullLogin()
          }
        } title: {
          Text("Log in")
        }
      }
      Spacer()
      Text("v 1.0.1")
      Text("© 2025 My Company, Inc.")
    }
    .alert(
      isPresented: $viewModel.showError,
      error: viewModel.loginError,
      actions: {},
    )
    .onAppear {
      Task {
        await viewModel.startShortLogin()
      }
    }
  }
}

#Preview {
  LoginView(
    viewModel: LoginViewModel(
      responder: AppViewModel(),
      fullLogin: LoginFlowFull(authService: AuthService()),
      shortLogin: LoginFlowShort(authService: AuthService()),
    ),
  )
}

struct WideButton<Content: View>: View {
  @MainActor var action: () -> Void
  @ViewBuilder var title: () -> Content

  var body: some View {
    HStack {
      Spacer()
      Button(
        action: {
          action()
        },
        label: {
          title()
            .font(.headline)
            .foregroundColor(.orange)
            .padding()
            .frame(width: 250, height: 60)
            .background(
              RoundedRectangle(cornerRadius: 10)
                .stroke(Color.yellow, lineWidth: 2),
            )
        },
      )
      Spacer()
    }
  }
}
