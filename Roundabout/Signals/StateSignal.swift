// =============================================================================================================================
// ROUNDABOUT - SIGNALS - STATE SIGNAL
// =============================================================================================================================
import Foundation

public protocol StateSignalType {
  func input(_ state: Any)
}

final public class StateSignal<T: Equatable, ApplicationStateType: State>: StateSignalType {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Types
  public typealias DidChangeHandler = ((T) -> Void)
  private typealias SubscriberId = ObjectIdentifier

  // MARK: Public Variables
  public var rawValue: T {
    didSet {
      if self.rawValue == oldValue { return }
      self.didChangeHandlers.forEach({ (_, didChangeHandler: DidChangeHandler) in didChangeHandler(self.rawValue) })
    }
  }

  // MARK: Private Variables
  private(set) var inputSource: ((ApplicationStateType) -> T)?
  private var subscribers: [SubscriberId: AnyObject] = [:]
  private var didChangeHandlers: [SubscriberId: DidChangeHandler] = [:]


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Initializers
  // ---------------------------------------------------------------------------------------------------------------------------
  public init(_ rawValue: T, source: @escaping ((ApplicationStateType) -> T)) {
    self.rawValue = rawValue
    self.inputSource = source
  }

  // MARK: Public Functions
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

  // MARK: Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func getSubscriberId(of object: AnyObject) -> SubscriberId {
    return ObjectIdentifier(object)
  }

}
