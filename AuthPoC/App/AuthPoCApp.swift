import SwiftUI

@main
struct AuthPoCApp: App {
  private let factory: any AppFactoring
  @StateObject private var authService: AuthService
  @StateObject private var viewModel: AppViewModel

  init() {
    let env = AppEnvironment.live()
    _authService = StateObject(wrappedValue: env.authService)
    _viewModel = StateObject(wrappedValue: env.factory.makeAppViewModel())
    factory = env.factory
  }

  var body: some Scene {
    WindowGroup {
      if viewModel.isAuthenticated {
        MainView(authService: authService)
      } else {
        factory.makeLoginView(
          auth: authService,
          loginResponder: viewModel,
        )
      }
    }
  }
}
