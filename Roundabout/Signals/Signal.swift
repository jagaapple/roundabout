// =============================================================================================================================
// ROUNDABOUT - SIGNALS - SIGNAL
// =============================================================================================================================
import Foundation

final public class Signal<T: Equatable> {

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
  private var subscribers: [SubscriberId: AnyObject] = [:]
  private var didChangeHandlers: [SubscriberId: DidChangeHandler] = [:]


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Initializers
  // ---------------------------------------------------------------------------------------------------------------------------
  public init(_ rawValue: T) {
    self.rawValue = rawValue
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

  // MARK: Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func getSubscriberId(of object: AnyObject) -> SubscriberId {
    return ObjectIdentifier(object)
  }

}
