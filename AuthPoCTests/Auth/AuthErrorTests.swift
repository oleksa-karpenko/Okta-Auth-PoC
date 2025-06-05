//
//  AuthErrorTests.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import Testing

@Suite
struct AuthErrorTests {
  @Test("errorDescription for .invalidCredentials")
  func invalidCredentialsDescription() {
    #expect(AuthError.invalidCredentials.errorDescription == "Invalid credentials")
  }

  @Test("errorDescription for .providerError with custom message")
  func providerErrorDescription() {
    let error = AuthError.providerError("Custom error message")
    #expect(error.errorDescription == "Custom error message")
  }

  @Test("errorDescription for .restoreStateFailed")
  func restoreStateFailedDescription() {
    #expect(AuthError.restoreStateFailed.errorDescription == "State restoration failed")
  }

  @Test("errorDescription for .configurationError")
  func configurationErrorDescription() {
    #expect(AuthError.configurationError.errorDescription == "Something wrong with the Okta configuration")
  }

  @Test("errorDescription for .defaultError")
  func defaultErrorDescription() {
    #expect(AuthError.defaultError.errorDescription == "Unknown error")
  }

  @Test("equality check for providerError with same message")
  func providerErrorEquality() {
    let a = AuthError.providerError("X")
    let b = AuthError.providerError("X")
    #expect(a == b)
  }

  @Test("inequality check for providerError with different messages")
  func providerErrorInequality() {
    let a = AuthError.providerError("X")
    let b = AuthError.providerError("Y")
    #expect(a != b)
  }
}
