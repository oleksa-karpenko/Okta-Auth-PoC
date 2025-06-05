//
//  MockCredentialsProvider.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC

struct MockCredentialsProvider: CredentialsProviding {
  let credentials: [String: String]
  func getCredentials() -> [String: String] {
    credentials
  }
}
