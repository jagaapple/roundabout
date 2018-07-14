// =============================================================================================================================
// ROUNDABOUT - CORE TYPES - STORE
// =============================================================================================================================
import Foundation

/// This type is a Store subscriber unique ID in order to distinguish some handlers owner.
public typealias StoreSubscriberId = ObjectIdentifier

final public class Store<ApplicationStateType: State> {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Types
  public typealias Middleware = ((Action, ApplicationStateType) -> Void)
  /// DidChangeHandler is called every time after an Action is dispatched.
  public typealias DidChangeHandler = ((ApplicationStateType) -> Void)
  /// An unique ID to set or remove willDispatchHandler or didDispatchHandler for some developers.
  public typealias HandlerId = String
  /// This type is closure called before an Action is dispatched then reduced by Application State's Reducer.
  public typealias WillDispatchHandler = ((ApplicationStateType, Action) -> Void)
  /// This type is closure called after an Action is dispatched then reduced by Application State's Reducer.
  public typealias DidDispatchHandler = ((ApplicationStateType, Action, ApplicationStateType) -> Void)
  /// This type is closure called after unsubscribing.
  public typealias DidUnsubscribeHandler = ((StoreSubscriberId) -> Void)

  // MARK: Public Variables
  public private(set) var applicationState: ApplicationStateType = ApplicationStateType.defaultState

  // MARK: Private Variables
  private let middleware: [Middleware]
  private var subscribers: [StoreSubscriberId: AnyObject] = [:]
  private var didChangeHandlers: [StoreSubscriberId: DidChangeHandler] = [:]
  private var willDispatchHandlers: [HandlerId: WillDispatchHandler] = [:]
  private var didDispatchHandlers: [HandlerId: DidDispatchHandler] = [:]
  private var didUnsubscribeHandlers: [HandlerId: DidUnsubscribeHandler] = [:]


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
  /// Subscribes in order to detect dispatchings and execute a specific processes. To avoid memory leaks, unsubscribe when
  /// detection become unnecessary.
  ///
  /// - Parameters:
  ///   - subscriber: Class or object in order to distinguish who has didChangeHandler.
  ///   - didChangeHandler: This closure is called every time after an Action is dispatched.
  public func subscribe(_ subscriber: AnyObject, didChange didChangeHandler: @escaping DidChangeHandler) {
    let newSubscriberId: StoreSubscriberId = self.getSubscriberId(of: subscriber)
    self.subscribers[newSubscriberId] = subscriber
    self.didChangeHandlers[newSubscriberId] = didChangeHandler

    didChangeHandler(self.applicationState)
  }

  /// Unsubscribes in order to free the memory allocated by the subscriber's didChangeHandler.
  ///
  /// - Parameter subscriber: Class or object in order to distinguish who has a registered didChangeHandler.
  public func unsubscribe(_ subscriber: AnyObject) {
    let subscriberId: StoreSubscriberId = self.getSubscriberId(of: subscriber)
    self.subscribers.removeValue(forKey: subscriberId)
    self.didChangeHandlers.removeValue(forKey: subscriberId)

    // Call handlers for some developers.
    self.didUnsubscribeHandlers.forEach({ (_, handler: DidUnsubscribeHandler) in handler(subscriberId) })
  }

  /// Dispatches an Action to a Store. The action is reduced by some States after dispatching.
  ///
  /// - Parameter action: Struct object of Action.
  public func dispatch(action: Action) {
    // Call middleware.
    self.middleware.forEach({ (ware: Middleware) in ware(action, self.applicationState) })

    // Call handlers for some developers.
    self.willDispatchHandlers.forEach({ (_, handler: WillDispatchHandler) in handler(self.applicationState, action) })

    // Dispatch.
    let oldApplicationState: ApplicationStateType = self.applicationState
    self.applicationState = ApplicationStateType.handleAction(state: self.applicationState, action: action)
    self.didChangeHandlers.forEach({ (_, didChangeHandler: DidChangeHandler) in didChangeHandler(self.applicationState) })

    // Call handlers for some developers.
    self.didDispatchHandlers.forEach({ (_, handler: DidDispatchHandler) in
      handler(self.applicationState, action, oldApplicationState)
    })
  }

  /// Sets a handler called before an Action is dispatched then reduced by Application State's Reducer.
  /// In generally, this method is used by related library developers.
  ///
  /// - Parameters:
  ///   - id: An unique ID in order to set or remove a handler. When a specific ID exists already, a handler is not set.
  ///   - handler: A handler is possible to get Application State and a dispatched Action as arguments before reduced.
  ///     - state: An Application State before reduced.
  ///     - action: A dispatched Action.
  public func setWillDispatchHandler(id: HandlerId, handler: @escaping WillDispatchHandler) {
    if self.willDispatchHandlers[id] != nil { return }
    self.willDispatchHandlers[id] = handler
  }

  /// Removes a handler called before an Action is dispatched then reduced by Application State's Reducer.
  /// In generally, this method is used by related library developers.
  ///
  /// - Parameter id: A target handler ID.
  public func removeWillDispatchHandler(id: HandlerId) {
    self.willDispatchHandlers.removeValue(forKey: id)
  }

  /// Sets a handler called after an Action is dispatched then reduced by Application State's Reducer.
  /// In generally, this method is used by related library developers.
  ///
  /// - Parameters:
  ///   - id: An unique ID in order to set or remove a handler. When a specific ID exists already, a handler is not set.
  ///   - handler: A handler is possible to get Application State, a dispatched Action, and old Application State as arguments
  ///     after reduced.
  ///     - newState: A new Application State after reduced.
  ///     - action: A dispatched Action.
  ///     - oldState: A old Application State before reduced.
  public func setDidDispatchHandler(id: HandlerId, handler: @escaping DidDispatchHandler) {
    if self.didDispatchHandlers[id] != nil { return }
    self.didDispatchHandlers[id] = handler
  }

  /// Removes a handler called after an Action is dispatched then reduced by Application State's Reducer.
  /// In generally, this method is used by related library developers.
  ///
  /// - Parameter id: A target handler ID.
  public func removeDidDispatchHandler(id: HandlerId) {
    self.didDispatchHandlers.removeValue(forKey: id)
  }

  /// Sets a handler called after unsubscribing from a subscriber.
  /// In generally, this method is used by related library developers.
  ///
  /// - Parameters:
  ///   - id: An unique ID in order to set or remove a handler. When a specific ID exists already, a handler is not set.
  ///   - handler: A handler is possible to get unsubscribed subscriber ID.
  ///     - subscriberId: An unsubscribed subscriber ID.
  public func setDidUnsubscribeHandler(id: HandlerId, handler: @escaping DidUnsubscribeHandler) {
    if self.didUnsubscribeHandlers[id] != nil { return }
    self.didUnsubscribeHandlers[id] = handler
  }

  /// Removes a handler called after unsubscribing from a subscriber.
  /// In generally, this method is used by related library developers.
  ///
  /// - Parameter id: A target handler ID.
  public func removeDidUnsubscribeHandler(id: HandlerId) {
    self.didUnsubscribeHandlers.removeValue(forKey: id)
  }

  /// Returns a subscriber unique ID in order to distinguish some handlers owner.
  /// In generally, this method is used by related library developers.
  ///
  /// - Parameter object: Subscriber class or object.
  /// - Returns: A subscriber unique ID.
  public func getSubscriberId(of object: AnyObject) -> StoreSubscriberId {
    return ObjectIdentifier(object)
  }

}
