// =============================================================================================================================
// DEMO - REDUX - APPLICATION STORE
// =============================================================================================================================
import Roundabout

// Define Store.
// You can define Store as a global variable calling an initializer of Store class, but Store is "Single Store" and should be
// guaranteed so define as Singleton class in this case.
// Thus, you can call methods of Store via `ApplicationStore.shared` .
final class ApplicationStore {

  typealias State = ApplicationState
  static var shared: Store<State> {
    self.cachedStore = self.cachedStore ?? Store<State>()
    return self.cachedStore
  }
  static private var cachedStore: Store<State>!

  // Disable an internal initializer.
  private init() {}

}
