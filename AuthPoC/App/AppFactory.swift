@MainActor
protocol AppFactoring {
  func makeAppViewModel() -> AppViewModel
  func makeLoginView(
    auth: any AuthServicing,
    loginResponder: any LoginResponder,
  ) -> LoginView<LoginViewModel>
}

final class AppFactory: AppFactoring {
  func makeAppViewModel() -> AppViewModel {
    AppViewModel()
  }

  func makeLoginView(
    auth: any AuthServicing,
    loginResponder: any LoginResponder,
  ) -> LoginView<LoginViewModel> {
    let loginFlow = makeFullLoginFlow(authService: auth)
    let shortLoginFlow = makeShortLoginFlow(authService: auth)
    let viewModel = LoginViewModel(
      responder: loginResponder,
      fullLogin: loginFlow,
      shortLogin: shortLoginFlow,
    )
    return LoginView(viewModel: viewModel)
  }

  private func makeFullLoginFlow(authService: any AuthServicing) -> LoginFlowFull {
    LoginFlowFull(authService: authService)
  }

  private func makeShortLoginFlow(authService: any AuthServicing) -> LoginFlowShort {
    LoginFlowShort(authService: authService)
  }
}
