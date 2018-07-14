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
  /// Creates a StateSignal to detect a value changes of Application State.
  ///
  /// **In generally, this initializer is called by** `store.createSignal(_:)` . **Maybe you don't need to call this directly**.
  ///
  /// - Parameters:
  ///   - rawValue: A default value to set as Signal raw value.
  ///   - source: A closure which returns a value to set a new value from Application State.
  public init(_ rawValue: T, source: @escaping ((ApplicationStateType) -> T)) {
    super.init(rawValue)

    self.inputSource = source
  }

  // MARK: Public Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  /// Sets a value from Application State using a closure.
  ///
  /// **In generally, this method is called by** `store.createSignal(_:)` . **Maybe you don't need to call this directly**.
  ///
  /// - Parameter state: A new Application State. If a State does not conform ApplicationStateType, it is ignored.
  public func input(_ state: Any) {
    guard let applicationState: ApplicationStateType = state as? ApplicationStateType else { return }
    guard let inputSource: ((ApplicationStateType) -> T) = self.inputSource else { return }
    self.rawValue = inputSource(applicationState)
  }

}
