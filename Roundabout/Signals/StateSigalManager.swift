// =============================================================================================================================
// ROUNDABOUT - SIGNALS - STATE SIGNAL MANAGER
// =============================================================================================================================
internal final class StateSignalManager {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Variables
  internal static let shared: StateSignalManager = StateSignalManager()

  // MARK: Private Variables
  private var signals: [StoreSubscriberId: [StateSignalType]] = [:]


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Initializers
  // ---------------------------------------------------------------------------------------------------------------------------
  private init() {
    // Disable an internal initializer in order to implement Singleton class.
  }

  // MARK: Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  internal func register(signals: [StateSignalType], of subscriberId: StoreSubscriberId) {
    self.signals[subscriberId] = signals
  }

  internal func removeSignals(of subscriberId: StoreSubscriberId) {
    self.signals.removeValue(forKey: subscriberId)
  }

  internal func inputAll(state: Any) {
    self.signals.forEach({ (_, signals: [StateSignalType]) in
      signals.forEach({ (signal: StateSignalType) in signal.input(state) })
    })
  }

}
