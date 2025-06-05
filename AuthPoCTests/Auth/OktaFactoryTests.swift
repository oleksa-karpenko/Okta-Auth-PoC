//
//  OktaFactoryTests.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import Testing

struct OktaFactoryTests {
  @Test
  func make_withValidCredentials_returnsOktaService() {
    let credentials: [String: String] = [
      "issuer": "https://example.com/oauth2/default",
      "clientId": "testclientid",
      "redirectUri": "com.example:/callback",
      "logoutRedirectUri": "com.example:/logout",
      "scopes": "openid, profile",
    ]
    let factory = DefaultOktaFactory()
    let service = factory.make(with: credentials)

    #expect(service is OktaServicing)
  }

  @Test
  func make_withInvalidCredentials_returnsNil() {
    let credentials = [
      "clientId": "missing_issuer_and_redirect_uri",
    ]
    let factory = DefaultOktaFactory()
    let service = factory.make(with: credentials)

    #expect(service == nil)
  }
}
