// =============================================================================================================================
// ROUNDABOUT - STORE
// =============================================================================================================================
import Foundation

public class Store<ApplicationStateType: State> {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define types.
  public typealias MiddlewareType = (Action, ApplicationStateType)

  // Define public variables.
  public let applicationState: ApplicationStateType = ApplicationStateType.defaultState

  // Define private variables.
  private var observers: [AnyObject] = []
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
    self.observers.append(observer)
  }

  public func unsubscribe(_ targetObserver: AnyObject) {
    let filteredObservers: [AnyObject] = self.observers.filter({ (observer: AnyObject) -> Bool in
      return (observer !== targetObserver)
    })
    self.observers = filteredObservers
  }

  public func dispatch(action: Action) {}

}
