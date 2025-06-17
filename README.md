# Okta Integration PoC

This is a **Proof of Concept (PoC)** iOS application demonstrating integration with **Okta** using the [Okta OIDC SDK for iOS](https://github.com/okta/okta-oidc-ios.git).

---

## 🔐 Authentication Flows

The sample includes two login flows:

- **LoginFlowFull**:  
  Used for **first-time login**. Prompts the user to enter their **username and password** via the Okta-hosted login page.

- **LoginFlowShort**:  
  Used for **returning users**. Attempts to refresh a previously issued token and log in silently using the refresh token, if available.

---

## 🧩 Architecture

- `AuthService` is an **abstract authentication interface**, decoupled from any Okta-specific logic.
- `OktaService` is the **concrete implementation** of authentication, relying on the `Okta-OIDC` SDK.
- All components are designed using **protocols and abstractions** to support testability and clean separation of concerns.

---

## 🧪 Features

- After successful login, the **main screen** displays the retrieved **Access Token**.
- The JWT Access Token is **decoded locally**, and the **payload (claims)** section is rendered as a dictionary.
- **Configuration values** (e.g., client ID, issuer, redirect URI) are stored in `Info.plist`.
  > ⚠️ The repository does **not contain any sensitive data**. To test this project, you must provide your own configuration values.

---

## 🧼 Code Quality

- Enforces styling rules using **SwiftLint**.
- Applies automatic formatting via **SwiftFormat**.
- Unit tests are provided to ensure correctness and improve confidence during changes.

---

## 📦 Dependencies

- [Okta OIDC iOS SDK](https://github.com/okta/okta-oidc-ios.git)

---

## 🚀 Getting Started

1. Clone the repository.
2. Open the project in Xcode.
3. Add your Okta config values to `Info.plist`:
   - `issuer`
   - `clientId`
   - `redirectUri`
4. Run the app and try both login flows.
