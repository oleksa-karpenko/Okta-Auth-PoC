
@testable import AuthPoC
import Foundation
import OktaOidc
import Testing
import UIKit

struct AuthServiceTests {
  private struct MockOkta: OktaServicing {
    var accessToken: String? = "token"
    var isAuthenticated: Bool = true
    var stateManager: OktaOidcStateManager? = nil

    var signInResult: Result<Void, AuthError> = .success(())
    var signOutResult: Result<Void, AuthError> = .success(())
    var renewResult: Result<Void, AuthError> = .success(())
    var restoreSuccess: Bool = true

    func signIn(from controller: UIViewController) async -> Result<Void, AuthError> {
      return signInResult
    }

    func signOut(from controller: UIViewController) async -> Result<Void, AuthError> {
      return signOutResult
    }

    func renew() async -> Result<Void, AuthError> {
      return renewResult
    }

    func restoreState() -> Bool {
      return restoreSuccess
    }
  }

  private struct MockFactory: OktaFactory {
    let service: OktaServicing
    func make(with credentials: [String: String]) -> OktaServicing? {
      return service
    }
  }

  @Test
  func accessTokenIsForwarded() {
    let okta = MockOkta()
    let service = AuthService(credentials: ["mock": "1"], factory: MockFactory(service: okta))
    #expect(service.accessToken == "token")
  }

  @Test
  func setCredentialsTriggersFactory() async {
    var okta = MockOkta()
    okta.accessToken = "new-token"
    let service = AuthService(factory: MockFactory(service: okta))
    await service.setCredentials(["mock": "1"])
    #expect(service.accessToken == "new-token")
  }

  @Test
  func logInDelegatesToOkta() async {
    let okta = MockOkta(signInResult: .success(()))
    let service = AuthService(credentials: ["mock": "1"], factory: MockFactory(service: okta))
    let result = await service.logIn(from: UIViewController())
    #expect(result.isSuccess)
  }

  @Test
  func logOutDelegatesToOkta() async {
    let okta = MockOkta(signOutResult: .success(()))
    let service = AuthService(credentials: ["mock": "1"], factory: MockFactory(service: okta))
    let result = await service.logOut(from: UIViewController())
    #expect(result.isSuccess)
  }

  @Test
  func restoreStateSuccess() async {
    let okta = MockOkta(restoreSuccess: true)
    let service = AuthService(credentials: ["mock": "1"], factory: MockFactory(service: okta))
    let result = await service.restoreState()
    #expect(result.isSuccess)
  }

  @Test
  func restoreStateFailure() async {
    let okta = MockOkta(restoreSuccess: false)
    let service = AuthService(credentials: ["mock": "1"], factory: MockFactory(service: okta))
    let result = await service.restoreState()
    #expect({
      if case let .failure(error) = result {
        return error == .restoreStateFailed
      }
      return false
    }())
  }

  @Test
  func renewTokenDelegatesToOkta() async {
    let okta = MockOkta(renewResult: .success(()))
    let service = AuthService(credentials: ["mock": "1"], factory: MockFactory(service: okta))
    let result = await service.renewToken()
    #expect(result.isSuccess)
  }
}

extension Result {
  var isSuccess: Bool {
    if case .success = self { return true }
    return false
  }

  var isFailure: Bool {
    !isSuccess
  }
}
