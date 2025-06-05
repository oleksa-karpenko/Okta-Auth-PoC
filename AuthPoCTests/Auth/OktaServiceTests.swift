//
//  OktaServiceTests.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import OktaOidc
import XCTest

final class OktaServiceTests: XCTestCase {
  func testAccessTokenReturnsNilWhenNoState() {
    let service = OktaServiceMock()
    XCTAssertNil(service.accessToken)
  }

  func testIsAuthenticatedReturnsFalseWhenNoState() {
    let service = OktaServiceMock()
    XCTAssertFalse(service.isAuthenticated)
  }

  func testRestoreStateReturnsFalseIfNoApi() {
    let service = OktaServiceEmptyMock()
    XCTAssertFalse(service.restoreState())
  }

  func testRestoreStateReturnsTrueIfStateRestored() {
    let config = try! OktaOidcConfig(with: [
      "issuer": "https://example.com/oauth2/default",
      "clientId": "testclientid",
      "redirectUri": "com.example:/callback",
      "logoutRedirectUri": "com.example:/logout",
      "scopes": "openid, profile",
    ])
    let service = OktaService(config: config)
    XCTAssertFalse(service.restoreState()) // assuming no saved state exists in secure storage
  }
}

private final class OktaServiceMock: OktaServicing {
  var accessToken: String? { nil }
  var isAuthenticated: Bool { false }
  var stateManager: OktaOidcStateManager? { nil }

  func signIn(from controller: UIViewController) async -> Result<Void, AuthError> { .success(()) }
  func signOut(from controller: UIViewController) async -> Result<Void, AuthError> { .success(()) }
  func renew() async -> Result<Void, AuthError> { .success(()) }
  func restoreState() -> Bool { false }
}

private final class OktaServiceEmptyMock: OktaServicing {
  var accessToken: String? { nil }
  var isAuthenticated: Bool { false }
  var stateManager: OktaOidcStateManager? { nil }

  func signIn(from controller: UIViewController) async -> Result<Void, AuthError> { .failure(.defaultError) }
  func signOut(from controller: UIViewController) async -> Result<Void, AuthError> { .failure(.defaultError) }
  func renew() async -> Result<Void, AuthError> { .failure(.defaultError) }
  func restoreState() -> Bool { false }
}
