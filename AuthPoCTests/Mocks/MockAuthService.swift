//
//  MockAuthService.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import UIKit

final class MockAuthService: AuthServicing {
  var accessToken: String? = "mockToken"
  var credentials: [String: String] = [:]

  var shouldSucceed: Bool
  var shouldRestoreStateSucceed: Bool
  var shouldRenewTokenSucceed: Bool

  var didLogIn = false
  var stateRestored = false
  var tokenRenewed = false
  var setCredentialsCalled = false

  init(
    shouldSucceed: Bool = true,
    shouldRestoreStateSucceed: Bool = true,
    shouldRenewTokenSucceed: Bool = true,
  ) {
    self.shouldSucceed = shouldSucceed
    self.shouldRestoreStateSucceed = shouldRestoreStateSucceed
    self.shouldRenewTokenSucceed = shouldRenewTokenSucceed
  }

  func setCredentials(_ credentials: [String: String]) async {
    self.credentials = credentials
    setCredentialsCalled = true
  }

  func logIn(from controller: UIViewController) async -> Result<Void, AuthError> {
    didLogIn = true
    return shouldSucceed ? .success(()) : .failure(.defaultError)
  }

  func logOut(from controller: UIViewController) async -> Result<Void, AuthError> {
    .success(())
  }

  func restoreState() async -> Result<Void, AuthError> {
    stateRestored = shouldRestoreStateSucceed
    return shouldRestoreStateSucceed ? .success(()) : .failure(.restoreStateFailed)
  }

  func renewToken() async -> Result<Void, AuthError> {
    tokenRenewed = shouldRenewTokenSucceed
    return shouldRenewTokenSucceed ? .success(()) : .failure(.defaultError)
  }
}
