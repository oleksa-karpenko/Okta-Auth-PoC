struct AppEnvironment {
  let authService: AuthService // must be a concrete type since later it will become @StateObject
  let mainViewModel: AppViewModel
  let factory: AppFactoring

  @MainActor static func live() -> AppEnvironment {
    let authService = AuthService()
    let factory = AppFactory()
    let viewModel = factory.makeAppViewModel()
    return AppEnvironment(
      authService: authService,
      mainViewModel: viewModel,
      factory: factory,
    )
  }
}
