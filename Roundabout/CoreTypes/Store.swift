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
  public typealias StateDidChangeHandler = ((ApplicationStateType) -> Void)
  private typealias SubscriberId = String

  // Define private variables.
  private let middleware: [Middleware]
  private var applicationState: ApplicationStateType = ApplicationStateType.defaultState
  private var subscribers: [SubscriberId: AnyObject] = [:]
  private var didChangeHandlers: [SubscriberId: StateDidChangeHandler] = [:]


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
  public func subscribe(_ observer: AnyObject, didChange didChangeHandler: @escaping StateDidChangeHandler) {
    let newSubscriberId: SubscriberId = self.generateNewSubscriberId()

    self.subscribers[newSubscriberId] = observer
    self.didChangeHandlers[newSubscriberId] = didChangeHandler

    didChangeHandler(self.applicationState)
  }

  public func unsubscribe(_ targetSubscriber: AnyObject) {
    let targetSubscriberId: SubscriberId? = self.subscribers.first(where: { (_, subscriber: AnyObject) -> Bool in
      return (targetSubscriber === subscriber)
    })?.key

    guard let subscriberId: SubscriberId = targetSubscriberId else { return }
    self.subscribers.removeValue(forKey: subscriberId)
    self.didChangeHandlers.removeValue(forKey: subscriberId)
  }

  public func dispatch(action: Action) {
    // Call middleware.
    self.middleware.forEach({ (ware: Middleware) in ware(action, self.applicationState) })

    // Dispatch.
    self.applicationState = ApplicationStateType.handleAction(state: self.applicationState, action: action)
    self.didChangeHandlers.forEach({ (_, didChangeHandler: StateDidChangeHandler) in didChangeHandler(self.applicationState) })
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func generateNewSubscriberId() -> SubscriberId {
    return UUID().uuidString
  }

}
