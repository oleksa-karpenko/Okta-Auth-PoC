struct LoginFlowShort: Step {
  var next: (any Step)?
  private let authService: any AuthServicing

  init(authService: any AuthServicing) {
    self.authService = authService
    next = buildChain(authService: authService)
  }

  private func buildChain(
    authService: any AuthServicing,
  ) -> any Step {
    RetrieveCredentials(
      next: RestoreState(
        authService: authService,
        next: RefreshToken(authService: authService),
      ),
      authService: authService,
    )
  }

  func execute() async -> Result<Void, AuthError> {
    return await next?.execute() ?? .failure(.defaultError)
  }
}
