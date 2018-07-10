// =============================================================================================================================
// ROUNDABOUT - SIGNALS - STATE SIGNAL
// =============================================================================================================================
import Foundation

public protocol StateSignalType {
  func input(_ state: Any)
}

final public class StateSignal<T: Equatable, ApplicationStateType: State>: StateSignalType {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define types.
  public typealias DidChangeHandler = ((T) -> Void)
  private typealias SubscriberId = ObjectIdentifier

  // Define public variables.
  public var rawValue: T {
    didSet {
      if self.rawValue == oldValue { return }
      self.didChangeHandlers.forEach({ (_, didChangeHandler: DidChangeHandler) in didChangeHandler(self.rawValue) })
    }
  }

  // Define private variables.
  private(set) var inputSource: ((ApplicationStateType) -> T)?
  private var subscribers: [SubscriberId: AnyObject] = [:]
  private var didChangeHandlers: [SubscriberId: DidChangeHandler] = [:]


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Initializers
  // ---------------------------------------------------------------------------------------------------------------------------
  public init(_ rawValue: T, source: @escaping ((ApplicationStateType) -> T)) {
    self.rawValue = rawValue
    self.inputSource = source
  }

  // Public Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  public func subscribe(_ subscriber: AnyObject, didChange didChangeHandler: @escaping DidChangeHandler) {
    let newSubscriberId: SubscriberId = self.getSubscriberId(of: subscriber)
    self.subscribers[newSubscriberId] = subscriber
    self.didChangeHandlers[newSubscriberId] = didChangeHandler

    didChangeHandler(self.rawValue)
  }

  public func unsubscribe(_ subscriber: AnyObject) {
    let subscriberId: SubscriberId = self.getSubscriberId(of: subscriber)
    self.subscribers.removeValue(forKey: subscriberId)
    self.didChangeHandlers.removeValue(forKey: subscriberId)
  }

  public func input(_ state: Any) {
    guard let applicationState: ApplicationStateType = state as? ApplicationStateType else { return }
    guard let inputSource: ((ApplicationStateType) -> T) = self.inputSource else { return }
    self.rawValue = inputSource(applicationState)
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func getSubscriberId(of object: AnyObject) -> SubscriberId {
    return ObjectIdentifier(object)
  }

}
