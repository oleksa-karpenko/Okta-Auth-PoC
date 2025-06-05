import Combine

protocol MainModel: ObservableObject {
  var isAuthenticated: Bool { get }
}

protocol LoginResponder {
  func didFinishLogin(with result: Result<Void, Error>)
}

protocol LogoutResponder {
  func didFinishLogout()
}

final class AppViewModel: MainModel {
  @Published var isAuthenticated: Bool = false
}

extension AppViewModel: LoginResponder {
  func didFinishLogin(with result: Result<Void, any Error>) {
    switch result {
    case .success:
      isAuthenticated = true
    case .failure:
      isAuthenticated = false
    }
  }
}

extension AppViewModel: LogoutResponder {
  func didFinishLogout() {
    isAuthenticated = false
  }
}
