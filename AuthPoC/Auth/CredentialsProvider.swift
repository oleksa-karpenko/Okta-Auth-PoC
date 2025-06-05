import Foundation

protocol CredentialsProviding {
  func getCredentials() -> [String: String]
}

struct PlistCredentialsProvider: CredentialsProviding {
  enum Keys: String, CaseIterable {
    case issuer = "ISSUER"
    case clientId = "CLIENT_ID"
    case redirectUri = "REDIRECT_URI"
    case logoutRedirectUri = "LOGOUT_REDIRECT_URI"
    case scopes = "SCOPES"

    var configurationName: String {
      switch self {
      case .issuer: return "issuer"
      case .clientId: return "clientId"
      case .redirectUri: return "redirectUri"
      case .logoutRedirectUri: return "logoutRedirectUri"
      case .scopes: return "scopes"
      }
    }
  }

  func getCredentials() -> [String: String] {
    var dictionary: [String: String] = [:]
    for key in Keys.allCases {
      if let value = Bundle.main.infoDictionary?[key.rawValue] as? String {
        dictionary[key.configurationName] = value
      }
    }
    return dictionary
  }
}
