import Foundation

@MainActor
protocol LoginModel<ErrorType>: ObservableObject {
  associatedtype ErrorType: LocalizedError

  var isLoading: Bool { get }
  var showError: Bool { get set }
  var loginError: ErrorType? { get set }

  func startFullLogin() async
  func startShortLogin() async
}
