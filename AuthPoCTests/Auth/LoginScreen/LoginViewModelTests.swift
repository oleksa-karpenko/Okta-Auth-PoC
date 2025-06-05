//
//  LoginViewModelTests.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import Testing

@MainActor
@Suite
struct LoginViewModelTests {
  class MockResponder: LoginResponder {
    var didLogin = false
    var loginResult: Result<Void, any Error>?

    func didFinishLogin(with result: Result<Void, any Error>) {
      didLogin = true
      loginResult = result
    }
  }

  struct SuccessFlow: Step {
    var next: (any AuthPoC.Step)?

    func execute() async -> Result<Void, AuthError> {
      .success(())
    }
  }

  struct FailureFlow: Step {
    var next: (any AuthPoC.Step)?

    func execute() async -> Result<Void, AuthError> {
      .failure(.defaultError)
    }
  }

  @Test
  func startFullLoginSuccess() async {
    let responder = MockResponder()
    let viewModel = LoginViewModel(
      responder: responder,
      fullLogin: SuccessFlow(),
      shortLogin: SuccessFlow(),
    )

    await viewModel.startFullLogin()

    #expect(responder.didLogin)
    #expect(responder.loginResult?.isSuccess == true, "Expected .success, but got \(String(describing: responder.loginResult))")
    #expect(!viewModel.isLoading)
    #expect(!viewModel.showError)
    #expect(viewModel.loginError == nil)
  }

  @Test
  func startFullLoginFailure() async {
    let responder = MockResponder()
    let viewModel = LoginViewModel(
      responder: responder,
      fullLogin: FailureFlow(),
      shortLogin: SuccessFlow(),
    )

    await viewModel.startFullLogin()

    #expect(!responder.didLogin)
    #expect(viewModel.showError)
    #expect(viewModel.loginError == .defaultError)
    #expect(!viewModel.isLoading)
  }

  @Test
  func startShortLoginSuccess() async {
    let responder = MockResponder()
    let viewModel = LoginViewModel(
      responder: responder,
      fullLogin: SuccessFlow(),
      shortLogin: SuccessFlow(),
    )

    await viewModel.startShortLogin()

    #expect(responder.loginResult?.isSuccess == true, "Expected .success, but got \(String(describing: responder.loginResult))")
    #expect(!viewModel.isLoading)
  }
}

// Protocol matching the contract of LoginFlowFull
protocol LoginFlowFullProtocol: Step {
  func execute() async -> Result<Void, AuthError>
}

// Protocol matching the contract of LoginFlowShort
protocol LoginFlowShortProtocol: Step {
  func execute() async -> Result<Void, AuthError>
}
