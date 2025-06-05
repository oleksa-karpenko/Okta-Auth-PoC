import OktaOidc

protocol OktaFactory {
  func make(with credentials: [String: String]) -> OktaServicing?
}

struct DefaultOktaFactory: OktaFactory {
  func make(with credentials: [String: String]) -> OktaServicing? {
    guard let config = try? OktaOidcConfig(with: credentials) else { return nil }
    return OktaService(config: config)
  }
}
