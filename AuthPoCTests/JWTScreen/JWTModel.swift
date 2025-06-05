//
//  JWTModel.swift
//  AuthPoC
//
//  Created by Oleksandr Karpenko on 05.06.2025.
//

@testable import AuthPoC
import Foundation
import Testing

@Suite
struct JWTViewModelTests {
  @Test("decodes token and populates claims including formatted exp/iat")
  func decodeValidToken() {
    let payload = [
      "sub": "1234567890",
      "name": "John Doe",
      "iat": 1_686_000_000,
      "exp": 1_686_003_600,
    ] as [String: Any]

    let base64 = try! JSONSerialization.data(withJSONObject: payload)
      .base64EncodedString()
      .replacingOccurrences(of: "+", with: "-")
      .replacingOccurrences(of: "/", with: "_")
      .replacingOccurrences(of: "=", with: "")

    let jwt = "header.\(base64).signature"

    let viewModel = JWTViewModel(token: jwt)
    viewModel.decodeToken()

    #expect(viewModel.claims["sub"] == "1234567890")
    #expect(viewModel.claims["name"] == "John Doe")
    #expect(viewModel.claims["expired at"] != nil)
    #expect(viewModel.claims["issued at"] != nil)
  }

  @Test("handles invalid JWT gracefully")
  func invalidJWT() {
    let viewModel = JWTViewModel(token: "invalid.jwt.token")
    viewModel.decodeToken()
    #expect(viewModel.claims.isEmpty)
  }

  @Test("returns nil if payload is not decodable")
  func decodeJWTPayloadFailsGracefully() {
    let viewModel = JWTViewModel(token: nil)
    let result = viewModel.decodeJWTPayload("broken")
    #expect(result == nil)
  }
}
