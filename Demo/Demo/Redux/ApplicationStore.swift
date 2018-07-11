// =============================================================================================================================
// DEMO - REDUX - APPLICATION STORE
// =============================================================================================================================
import Roundabout

// Define a Store
// -----------------------------------------------------------------------------------------------------------------------------
// You can define a Store as a global variable calling an initializer of Store class, but Store should be "Single Store" and
// we must be guaranteed, so define as Singleton class in this case.
// Thus, you can call methods of Store via `ApplicationStore.shared` .
final class ApplicationStore {

  typealias State = ApplicationState
  static var shared: Store<State> {
    self.cachedStore = self.cachedStore ?? Store<State>()
    return self.cachedStore
  }
  static private var cachedStore: Store<State>!

  // Disable an internal initializer in order to implement Singleton class.
  private init() {}

}
