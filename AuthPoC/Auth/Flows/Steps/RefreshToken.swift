struct RefreshToken: Step {
  var next: (any Step)?
  private let authService: any AuthServicing

  init(authService: any AuthServicing, next: (any Step)? = nil) {
    self.authService = authService
    self.next = next
  }

  func execute() async -> Result<Void, AuthError> {
    guard case .success = await authService.renewToken() else {
      print("### RefreshToken failed")
      return .failure(.restoreStateFailed)
    }
    print("### RefreshToken succeeded")
    return await next?.execute() ?? .success(())
  }
}
