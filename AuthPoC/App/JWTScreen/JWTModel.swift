import Combine
import Foundation

class JWTViewModel: ObservableObject {
  init(
    token: String?,
    claims: [String: String] = [:]
  ) {
    self.token = token ?? ""
    self.claims = claims
  }

  @Published var token: String {
    didSet {
      decodeToken()
    }
  }

  @Published var claims: [String: String]

  func decodeToken() {
    guard let payload = decodeJWTPayload(token) else { return }

    var result = payload.mapValues { String(describing: $0) }

    if let exp = formattedDate(for: payload, key: "exp") {
      result["expired at"] = exp
    }
    if let iat = formattedDate(for: payload, key: "iat") {
      result["issued at"] = iat
    }

    claims = result
  }

  private func formattedDate(for payload: [String: Any], key: String) -> String? {
    guard let rawValue = payload[key],
          let timestamp = Double(String(describing: rawValue))
    else {
      return nil
    }

    let date = Date(timeIntervalSince1970: timestamp)
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter.string(from: date)
  }

  func decodeJWTPayload(_ jwt: String) -> [String: Any]? {
    let segments = jwt.split(separator: ".")
    guard segments.count == 3 else { return nil }

    let payloadSegment = segments[1]
    var base64 = payloadSegment
      .replacingOccurrences(of: "-", with: "+")
      .replacingOccurrences(of: "_", with: "/")

    // Pad with '=' to make length multiple of 4
    while base64.count % 4 != 0 {
      base64 += "="
    }

    guard let data = Data(base64Encoded: base64),
          let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else {
      return nil
    }

    return json
  }
}
