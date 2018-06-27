// =============================================================================================================================
// ROUNDABOUT - STORE
// =============================================================================================================================
import Foundation

public class Store<ApplicationStateType: State> {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define types.
  public typealias Middleware = (Action, ApplicationStateType) -> Void
  public typealias StateDidChangeHandler = (ApplicationStateType) -> Void
  private typealias SubscriberId = String

  // Define public variables.
  private var applicationState: ApplicationStateType = ApplicationStateType.defaultState
  private var subscribers: [SubscriberId: AnyObject] = [:]
  private var didChangeHandlers: [SubscriberId: StateDidChangeHandler] = [:]
  private var middleware: [Middleware] = []


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
    let newSubscriberId: SubscriberId = self.getNewSubscriberId()

    self.subscribers[newSubscriberId] = observer
    self.didChangeHandlers[newSubscriberId] = didChangeHandler
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
  private func getNewSubscriberId() -> SubscriberId {
    return UUID().uuidString
  }

}
