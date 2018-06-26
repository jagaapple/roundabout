// =============================================================================================================================
// ROUNDABOUT - STORE
// =============================================================================================================================
import Foundation

public class Store<ApplicationStateType: State> {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define types.
  typealias SubscriberId = String
  typealias MiddlewareType = (Action, ApplicationStateType) -> Void

  // Define public variables.
  public var applicationState: ApplicationStateType = ApplicationStateType.defaultState

  // Define private variables.
  private var subscribers: [SubscriberId: AnyObject] = [:]
  private var middleware: [MiddlewareType] = []


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Initializers
  // ---------------------------------------------------------------------------------------------------------------------------
  init(middleware: [MiddlewareType] = []) {
    self.middleware = middleware
  }

  // Public Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  public func subscribe(_ observer: AnyObject) {
    let newSubscriberId: SubscriberId = self.getNewSubscriberId()
    self.subscribers[newSubscriberId] = observer
  }

  public func unsubscribe(_ targetSubscriber: AnyObject) {
    let targetSubscriberId: SubscriberId? = self.subscribers.first(where: { (_, subscriber: AnyObject) -> Bool in
      return (targetSubscriber === subscriber)
    })?.key

    guard let subscriberId: SubscriberId = targetSubscriberId else { return }
    self.subscribers.removeValue(forKey: subscriberId)
  }

  public func dispatch(action: Action) {
    // Call middleware.
    self.middleware.forEach({ (ware: MiddlewareType) in ware(action, self.applicationState) })

    // Dispatch.
    self.applicationState = ApplicationStateType.handleAction(state: self.applicationState, action: action)
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func getNewSubscriberId() -> SubscriberId {
    return UUID().uuidString
  }

}
