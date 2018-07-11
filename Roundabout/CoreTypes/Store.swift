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

  public func subscribe(_ subscriber: AnyObject, didChange didChangeHandler: @escaping DidChangeHandler) {
    let newSubscriberId: SubscriberId = self.getSubscriberId(of: subscriber)
    self.subscribers[newSubscriberId] = subscriber
    self.didChangeHandlers[newSubscriberId] = didChangeHandler

    didChangeHandler(self.applicationState)
  }

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
