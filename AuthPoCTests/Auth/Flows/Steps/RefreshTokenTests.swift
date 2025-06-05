//
//  RefreshTokenTests.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import Testing
import UIKit

struct RefreshTokenTests {
  @Test
  func refreshTokenSuccess() async {
    let mockService = MockAuthService(shouldSucceed: true)
    let step = RefreshToken(authService: mockService)
    let result = await step.execute()

    if case .success = result {
      #expect(true)
    }
    #expect(mockService.tokenRenewed)
  }

  @Test
  func refreshTokenFailure() async {
    let mockService = MockAuthService(shouldSucceed: true)
    mockService.shouldSucceed = false
    let step = RefreshToken(authService: mockService)
    let result = await step.execute()

    if case let .failure(error) = result {
      #expect(error == .restoreStateFailed)
    }

    #expect(mockService.tokenRenewed)
  }
}
