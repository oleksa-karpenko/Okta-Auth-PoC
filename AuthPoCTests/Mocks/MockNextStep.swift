//
//  MockNextStep.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC

final class MockNextStep: Step {
  var next: (any AuthPoC.Step)?

  var executed = false

  func execute() async -> Result<Void, AuthError> {
    executed = true
    return .success(())
  }
}
