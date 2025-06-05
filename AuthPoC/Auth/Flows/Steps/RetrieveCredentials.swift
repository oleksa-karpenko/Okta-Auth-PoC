import Foundation

final class RetrieveCredentials: Step {
  var next: (any Step)?
  let authService: any AuthServicing
  let credentialsProvider: CredentialsProviding

  init(
    next: (any Step)? = nil,
    authService: any AuthServicing,
    credentialsProvider: CredentialsProviding = PlistCredentialsProvider()
  ) {
    self.next = next
    self.authService = authService
    self.credentialsProvider = credentialsProvider
  }

  func execute() async -> Result<Void, AuthError> {
    guard authService.credentials.isEmpty else {
      return await runNext()
    }

    let credentials = credentialsProvider.getCredentials()
    guard !credentials.isEmpty else {
      return .failure(.invalidCredentials)
    }

    await authService.setCredentials(credentials)
    return await runNext()
  }

  private func runNext() async -> Result<Void, AuthError> {
    if let nextStep = next {
      return await nextStep.execute()
    }
    return .success(())
  }
}
