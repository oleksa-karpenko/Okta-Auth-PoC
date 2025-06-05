protocol Step {
  var next: Step? { get set }
  func execute() async -> Result<Void, AuthError>
}
