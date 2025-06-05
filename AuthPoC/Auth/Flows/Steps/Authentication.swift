import UIKit

final class Authentication: Step {
  var next: (any Step)?
  var authService: any AuthServicing

  init(next: (any Step)? = nil, authService: any AuthServicing) {
    self.next = next
    self.authService = authService
  }

  func execute() async -> Result<Void, AuthError> {
    guard let controller = await makeController() else {
      return .failure(AuthError.defaultError)
    }
    return await authService.logIn(from: controller)
  }

  @MainActor
  private func makeController() -> UIViewController? {
    KeyWindow.controller
  }
}
