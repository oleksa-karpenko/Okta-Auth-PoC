//
//  RestoreStateTests.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import Testing
import UIKit

@MainActor
@Suite struct RestoreStateTests {
  @Test func restoreStateSuccess() async {
    let service = MockAuthService(shouldSucceed: true)
    let step = RestoreState(authService: service)
    let result = await step.execute()

    if case .success = result {
      #expect(true)
    }
  }

  @Test func restoreStateFailure() async {
    let service = MockAuthService(shouldSucceed: false)
    let step = RestoreState(authService: service)
    let result = await step.execute()

    if case let .failure(error) = result {
      #expect(error == .restoreStateFailed)
    }
  }
}
