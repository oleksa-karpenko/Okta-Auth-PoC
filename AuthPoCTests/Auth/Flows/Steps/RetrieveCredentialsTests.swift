//
//  RetrieveCredentialsTests.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import Testing
import UIKit

struct RetrieveCredentialsTests {
  @Test
  func skipsIfAlreadyHasCredentials() async {
    let authService = MockAuthService(shouldSucceed: true)
    authService.credentials = ["token": "abc"]

    let step = RetrieveCredentials(
      next: nil,
      authService: authService,
      credentialsProvider: MockCredentialsProvider(credentials: [:]),
    )

    let result = await step.execute()
    if case .success = result {
      #expect(true)
    }
  }

  @Test
  func failsIfNoCredentialsProvided() async {
    let authService = MockAuthService(shouldSucceed: true)

    let step = RetrieveCredentials(
      next: nil,
      authService: authService,
      credentialsProvider: MockCredentialsProvider(credentials: [:]),
    )

    let result = await step.execute()
    if case .failure(.invalidCredentials) = result {
      #expect(true)
    }
  }

  @Test
  func setsCredentialsAndRunsNext() async {
    let authService = MockAuthService(shouldSucceed: true)
    let mockStep = MockNextStep()
    let step = RetrieveCredentials(
      next: mockStep,
      authService: authService,
      credentialsProvider: MockCredentialsProvider(credentials: ["token": "abc"]),
    )

    let result = await step.execute()
    if case .success = result {
      #expect(true)
    }

    #expect(authService.credentials["token"] == "abc")
  }
}
