// =============================================================================================================================
// ROUNDABOUT - CORE TYPES - STORE
// =============================================================================================================================
import Foundation

final public class Store<ApplicationStateType: State> {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define types.
  public typealias Middleware = ((Action, ApplicationStateType) -> Void)
  public typealias DidChangeHandler = ((ApplicationStateType) -> Void)
  private typealias SubscriberId = ObjectIdentifier

  // Define private variables.
  private let middleware: [Middleware]
  private var applicationState: ApplicationStateType = ApplicationStateType.defaultState
  private var subscribers: [SubscriberId: AnyObject] = [:]
  private var didChangeHandlers: [SubscriberId: DidChangeHandler] = [:]


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Initializers
  // ---------------------------------------------------------------------------------------------------------------------------
  public init(middleware: [Middleware] = []) {
    self.middleware = middleware
  }

  // Public Functions
  // ---------------------------------------------------------------------------------------------------------------------------
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

  public func dispatch(action: Action) {
    // Call middleware.
    self.middleware.forEach({ (ware: Middleware) in ware(action, self.applicationState) })

    // Dispatch.
    self.applicationState = ApplicationStateType.handleAction(state: self.applicationState, action: action)
    self.didChangeHandlers.forEach({ (_, didChangeHandler: DidChangeHandler) in didChangeHandler(self.applicationState) })
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func getSubscriberId(of object: AnyObject) -> SubscriberId {
    return ObjectIdentifier(object)
  }

}
