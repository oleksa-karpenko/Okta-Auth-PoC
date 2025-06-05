final class LoginFlowFull: Step {
  var next: Step?

  init(authService: any AuthServicing) {
    next = buildChain(
      authService: authService,
    )
  }

  private func buildChain(
    authService: any AuthServicing,
  ) -> any Step {
    RetrieveCredentials(
      next: Authentication(authService: authService),
      authService: authService,
    )
  }

  func execute() async -> Result<Void, AuthError> {
    await next?.execute() ?? .failure(.defaultError)
  }
}
