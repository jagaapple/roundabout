// =============================================================================================================================
// ROUNDABOUT - CORE TYPES - STORE
// =============================================================================================================================
import Foundation

final public class Store<ApplicationStateType: State> {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Types
  public typealias Middleware = ((Action, ApplicationStateType) -> Void)
  /// DidChangeHandler is called every time after an Action is dispatched.
  public typealias DidChangeHandler = ((ApplicationStateType) -> Void)
  private typealias SubscriberId = ObjectIdentifier

  // MARK: Private Variables
  private let middleware: [Middleware]
  private var applicationState: ApplicationStateType = ApplicationStateType.defaultState
  private var subscribers: [SubscriberId: AnyObject] = [:]
  private var didChangeHandlers: [SubscriberId: DidChangeHandler] = [:]
  private var signals: [StateSignalType] = []


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Initializers
  // ---------------------------------------------------------------------------------------------------------------------------
  /// Creates a Store for the specified Application State.
  ///
  /// Single source of truth in Roundabout, so the application should have a single Store.
  ///
  /// - Parameter middleware: Ordered list of middlewares processed before acting Application State's reducer.
  public init(middleware: [Middleware] = []) {
    self.middleware = middleware
  }

  // MARK: Public Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  public func subscribe(_ subscriber: AnyObject, connectTo signals: [StateSignalType]) {
    let newSubscriberId: SubscriberId = self.getSubscriberId(of: subscriber)
    self.subscribers[newSubscriberId] = subscriber

    self.signals = signals
  }

  /// Subscribes in order to detect dispatchings and execute a specific processes. To avoid memory leaks, unsubscribe when
  /// detection become unnecessary.
  ///
  /// - Parameters:
  ///   - subscriber: Class or object in order to distinguish who has didChangeHandler.
  ///   - didChangeHandler: This closure is called every time after an Action is dispatched.
  public func subscribe(_ subscriber: AnyObject, didChange didChangeHandler: @escaping DidChangeHandler) {
    let newSubscriberId: SubscriberId = self.getSubscriberId(of: subscriber)
    self.subscribers[newSubscriberId] = subscriber
    self.didChangeHandlers[newSubscriberId] = didChangeHandler

    didChangeHandler(self.applicationState)
  }

  /// Unsubscribes in order to free the memory allocated by the subscriber's didChangeHandler.
  ///
  /// - Parameter subscriber: Class or object in order to distinguish who has a registered didChangeHandler.
  public func unsubscribe(_ subscriber: AnyObject) {
    let subscriberId: SubscriberId = self.getSubscriberId(of: subscriber)
    self.subscribers.removeValue(forKey: subscriberId)
    self.didChangeHandlers.removeValue(forKey: subscriberId)
  }

  public func createSignal<T: Equatable>(
    _ source: @escaping ((ApplicationStateType) -> T)
  ) -> StateSignal<T, ApplicationStateType> {
    let defaultValue: T = source(self.applicationState)
    return StateSignal(defaultValue, source: source)
  }


  /// Dispatch an Action to a Store. The action is reduced by some States after dispatching.
  ///
  /// - Parameter action: Struct object of Action.
  public func dispatch(action: Action) {
    // Call middleware.
    self.middleware.forEach({ (ware: Middleware) in ware(action, self.applicationState) })

    // Dispatch.
    self.applicationState = ApplicationStateType.handleAction(state: self.applicationState, action: action)
    self.didChangeHandlers.forEach({ (_, didChangeHandler: DidChangeHandler) in didChangeHandler(self.applicationState) })

    // Input new States into Signals.
    self.signals.forEach({ (signal: StateSignalType) in signal.input(self.applicationState) })
  }

  // MARK: Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func getSubscriberId(of object: AnyObject) -> SubscriberId {
    return ObjectIdentifier(object)
  }

}
