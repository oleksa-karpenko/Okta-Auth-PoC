import OktaOidc

protocol OktaServicing {
  var accessToken: String? { get }
  var isAuthenticated: Bool { get }
  var stateManager: OktaOidcStateManager? { get }

  func signIn(from controller: UIViewController) async -> Result<Void, AuthError>
  func signOut(from controller: UIViewController) async -> Result<Void, AuthError>
  func renew() async -> Result<Void, AuthError>
  func restoreState() -> Bool
}

final class OktaService: OktaServicing {
  var oktaApi: OktaOidc?

  var stateManager: OktaOidcStateManager?

  var accessToken: String? {
    stateManager?.accessToken
  }

  var isAuthenticated: Bool {
    stateManager?.authState.isAuthorized ?? false
  }

  init(config: OktaOidcConfig) {
    oktaApi = try? OktaOidc(configuration: config)
  }

  func signIn(from controller: UIViewController) async -> Result<Void, AuthError> {
    guard let oktaApi else { return .failure(.defaultError) }

    return await withCheckedContinuation { continuation in
      oktaApi.signInWithBrowser(from: controller) { state, error in
        self.stateManager = state
        let result: Result<Void, AuthError> = error == nil
          ? .success(())
          : .failure(.providerError(error?.localizedDescription ?? "Unknown error"))
        continuation.resume(returning: result)
      }
    }
  }

  func signOut(from controller: UIViewController) async -> Result<Void, AuthError> {
    guard
      let oktaApi,
      let stateManager
    else {
      return .failure(.defaultError)
    }

    return await withCheckedContinuation { continuation in
      oktaApi.signOutOfOkta(stateManager, from: controller) { error in
        let result: Result<Void, AuthError> = error == nil
          ? .success(())
          : .failure(.providerError(error?.localizedDescription ?? "Unknown error"))
        continuation.resume(returning: result)
      }
    }
  }

  func renew() async -> Result<Void, AuthError> {
    guard let stateManager else { return .failure(.defaultError) }

    return await withCheckedContinuation { continuation in
      stateManager.renew { newState, error in
        self.stateManager = newState
        let result: Result<Void, AuthError> = error == nil
          ? .success(())
          : .failure(.providerError(error?.localizedDescription ?? "Unknown error"))
        continuation.resume(returning: result)
      }
    }
  }

  func restoreState() -> Bool {
    guard let oktaApi else { return false }
    stateManager = OktaOidcStateManager.readFromSecureStorage(for: oktaApi.configuration)
    return stateManager != nil
  }
}
