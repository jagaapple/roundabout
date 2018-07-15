// =============================================================================================================================
// ROUNDABOUT - SIGNALS - SIGNAL
// =============================================================================================================================
public class Signal<T: Equatable> {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Types
  /// DidChangeHandler is called every time when a raw value is changed.
  public typealias DidChangeHandler = ((T) -> Void)
  internal typealias SubscriberId = ObjectIdentifier

  // MARK: Public Variables
  /// A target value to detect changes. When this value is set a new value, a handler is called, but this value is set the same
  /// value, it is not called.
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
  /// Creates a Signal to detect a value changes.
  ///
  /// - Parameter rawValue: A target value to detect changes.
  public init(_ rawValue: T) {
    self.rawValue = rawValue
  }

  // MARK: Public Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  /// Subscribes in order to detect a value changes and execute a specific processes. To avoid memory leaks, unsubscribe when
  /// detection become unnecessary.
  ///
  /// - Parameters:
  ///   - subscriber: Class or object in order to distinguish who has didChangeHandler.
  ///   - didChangeHandler: This closure is called every time when the value is changed.
  public func subscribe(_ subscriber: AnyObject, didChange didChangeHandler: @escaping DidChangeHandler) {
    let newSubscriberId: SubscriberId = self.getSubscriberId(of: subscriber)
    self.subscribers[newSubscriberId] = subscriber
    self.didChangeHandlers[newSubscriberId] = didChangeHandler

    didChangeHandler(self.rawValue)
  }

  /// Unsubscribes in order to free the memory allocated by the subscriber's didChangeHandler.
  ///
  /// - Parameter subscriber: Class or object in order to distinguish who has a registered didChangeHandler.
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
