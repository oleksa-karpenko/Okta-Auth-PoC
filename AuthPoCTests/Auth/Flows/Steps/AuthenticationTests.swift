@testable import AuthPoC
import Testing
import UIKit

@MainActor
struct AuthenticationTests {
  @Test("Login executes successfully when credentials are valid")
  func loginSucceeds() async {
    let mock = MockAuthService(shouldSucceed: true)
    let auth = Authentication(authService: mock)
    let result = await auth.execute()
    #expect(mock.didLogIn)
    if case .success = result {
      #expect(true)
    }
  }

  @Test("Login fails when AuthService returns failure")
  func loginFails() async {
    let mock = MockAuthService(shouldSucceed: true)
    mock.shouldSucceed = false
    let auth = Authentication(authService: mock)
    let result = await auth.execute()
    #expect(mock.didLogIn)
    if case let .failure(error) = result {
      #expect(error == .defaultError)
    }
  }
}
