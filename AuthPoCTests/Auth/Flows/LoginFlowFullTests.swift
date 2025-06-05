//
//  LoginFlowFullTests.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import Testing
import UIKit

final class LoginFlowFullTests {
  @Test
  func executeReturnsSuccess() async {
    let authService = MockAuthService(shouldSucceed: true)
    let flow = LoginFlowFull(authService: authService)
    let result = await flow.execute()

    #expect(result.isSuccess, "Expected .success, but got \(result)")
  }
}
