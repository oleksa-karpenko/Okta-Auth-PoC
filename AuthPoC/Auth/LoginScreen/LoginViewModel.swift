import Combine
import Foundation

@MainActor
final class LoginViewModel: LoginModel {
  @Published var isLoading: Bool = false
  var showError: Bool = false

  var loginError: AuthError?

  private let responder: any LoginResponder
  private let fullLoginFlow: Step
  private let shortLoginFlow: Step

  init(
    responder: any LoginResponder,
    fullLogin: Step,
    shortLogin: Step
  ) {
    self.responder = responder
    fullLoginFlow = fullLogin
    shortLoginFlow = shortLogin
  }

  func startFullLogin() async {
    isLoading = true
    defer { isLoading = false }
    let result = await fullLoginFlow.execute()
    isLoading = false
    switch result {
    case .success:
      responder.didFinishLogin(with: .success(()))
    case let .failure(error):
      loginError = error
      showError = true
    }
  }

  func startShortLogin() async {
    isLoading = true

    defer { isLoading = false }
    let result = await shortLoginFlow.execute()
    if case .success = result {
      responder.didFinishLogin(with: .success(()))
    }
  }
}
