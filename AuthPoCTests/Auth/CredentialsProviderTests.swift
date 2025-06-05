//
//  CredentialsProviderTests.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import Foundation
import Testing

struct CredentialsProviderTests {
  @Test
  func getCredentials_returnsExpectedValuesFromPlist() {
    let expected: [String: String] = [
      "ISSUER": "https://example.com/oauth2/default",
      "CLIENT_ID": "test-client-id",
      "REDIRECT_URI": "com.example:/callback",
      "LOGOUT_REDIRECT_URI": "com.example:/logout",
      "SCOPES": "openid, profile",
    ]

    // Simulate the provider working on this dictionary
    let provider = TestablePlistCredentialsProvider(fakeInfo: expected)
    let credentials = provider.getCredentials()

    #expect(credentials["issuer"] == expected["ISSUER"])
    #expect(credentials["clientId"] == expected["CLIENT_ID"])
    #expect(credentials["redirectUri"] == expected["REDIRECT_URI"])
    #expect(credentials["logoutRedirectUri"] == expected["LOGOUT_REDIRECT_URI"])
    #expect(credentials["scopes"] == expected["SCOPES"])
  }
}

private struct TestablePlistCredentialsProvider: CredentialsProviding {
  let fakeInfo: [String: String]

  func getCredentials() -> [String: String] {
    var dictionary: [String: String] = [:]
    for key in PlistCredentialsProvider.Keys.allCases {
      if let value = fakeInfo[key.rawValue] {
        dictionary[key.configurationName] = value
      }
    }
    return dictionary
  }
}
