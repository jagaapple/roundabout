// =============================================================================================================================
// ROUNDABOUT - SIGNALS - STATE SIGNAL
// =============================================================================================================================
import Foundation

final public class StateSignal<T: Equatable, ApplicationStateType: State>: Signal<T>, StateSignalType {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Private Variables
  private var inputSource: ((ApplicationStateType) -> T)?


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Initializers
  // ---------------------------------------------------------------------------------------------------------------------------
  public init(_ rawValue: T, source: @escaping ((ApplicationStateType) -> T)) {
    super.init(rawValue)

    self.inputSource = source
  }

  // MARK: Public Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  public func input(_ state: Any) {
    guard let applicationState: ApplicationStateType = state as? ApplicationStateType else { return }
    guard let inputSource: ((ApplicationStateType) -> T) = self.inputSource else { return }
    self.rawValue = inputSource(applicationState)
  }

}
