import Foundation

enum AuthError: LocalizedError, Equatable {
  case invalidCredentials
  case providerError(String)
  case restoreStateFailed
  case configurationError
  case defaultError

  var errorDescription: String? {
    switch self {
    case .invalidCredentials:
      return "Invalid credentials"
    case let .providerError(message):
      return message
    case .restoreStateFailed:
      return "State restoration failed"
    case .configurationError:
      return "Something wrong with the Okta configuration"
    case .defaultError:
      return "Unknown error"
    }
  }
}
