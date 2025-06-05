//
//  LoginFlowShortTests.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import Testing

@Suite
struct LoginFlowShortTests {
  @Test
  func loginFlowShort_SuccessPath() async {
    let service = MockAuthService(shouldSucceed: true)
    let flow = LoginFlowShort(authService: service)
    let result = await flow.execute()
    #expect(result.isSuccess)
  }

  @Test
  func loginFlowShort_FailsIfRestoreFails() async {
    let service = MockAuthService(shouldSucceed: true)
    service.shouldRestoreStateSucceed = false
    let flow = LoginFlowShort(authService: service)
    let result = await flow.execute()
    switch result {
    case let .failure(error):
      #expect(error == .restoreStateFailed)
    default:
      let isOk = false
      #expect(isOk == false, "Expected failure(.restoreStateFailed), got \(result)")
    }
  }

  @Test
  func loginFlowShort_FailsIfRenewFails() async {
    let service = MockAuthService(shouldSucceed: true)
    service.shouldRenewTokenSucceed = false
    let flow = LoginFlowShort(authService: service)
    let result = await flow.execute()

    switch result {
    case let .failure(error):
      #expect(error == .restoreStateFailed)
    default:
      let isOk = false
      #expect(isOk == false, "Expected failure(.restoreStateFailed), got \(result)")
    }
  }
}
