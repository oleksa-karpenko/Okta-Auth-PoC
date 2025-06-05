import Combine
import UIKit

protocol AuthServicing: ObservableObject {
  var accessToken: String? { get }
  var credentials: [String: String] { get }

  func setCredentials(_ credentials: [String: String]) async
  func logIn(from controller: UIViewController) async -> Result<Void, AuthError>
  func logOut(from controller: UIViewController) async -> Result<Void, AuthError>
  func restoreState() async -> Result<Void, AuthError>
  func renewToken() async -> Result<Void, AuthError>
}

// @MainActor
class AuthService: AuthServicing {
  private(set) var credentials: [String: String] {
    didSet {
      configureOkta()
    }
  }

  private let oktaFactory: OktaFactory
  private var okta: OktaServicing?

  var accessToken: String? {
    okta?.accessToken
  }

  init(credentials: [String: String] = [:], factory: OktaFactory = DefaultOktaFactory()) {
    self.credentials = credentials
    oktaFactory = factory
    configureOkta()
  }

  private func configureOkta() {
    okta = credentials.isEmpty ? nil : oktaFactory.make(with: credentials)
  }

  func setCredentials(_ credentials: [String: String]) async {
    self.credentials = credentials
  }

  func logIn(from controller: UIViewController) async -> Result<Void, AuthError> {
    guard let okta else { return .failure(.defaultError) }
    return await okta.signIn(from: controller)
  }

  func logOut(from controller: UIViewController) async -> Result<Void, AuthError> {
    guard let okta else { return .success(()) }
    return await okta.signOut(from: controller)
  }

  func restoreState() async -> Result<Void, AuthError> {
    guard let okta else {
      return .failure(.defaultError)
    }

    let success = okta.restoreState()
    if success {
      return .success(())
    }

    return .failure(.restoreStateFailed)
  }

  func renewToken() async -> Result<Void, AuthError> {
    guard let okta else { return .success(()) }
    return await okta.renew()
  }
}
