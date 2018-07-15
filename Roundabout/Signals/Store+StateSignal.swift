// =============================================================================================================================
// ROUNDABOUT - SIGNALS - STORE + STATE SIGNAL
// =============================================================================================================================
extension Store {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  static fileprivate var handlerId: HandlerId { return "Roundabout/StateSignal" }


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Public Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  /// Creates a StateSignal optimized for a Store. When suscribing a Store with created signals by this method, signal's raw
  /// values are set from Application State automatically.
  ///
  /// ```swift
  /// let userNameSignal = store.createSignal { $0.user.name }
  /// store.subscribe(self, connectTo: [userNameSignal])
  /// ```
  ///
  /// - Parameter source: A closure to return a value in order to set a new value from Application State.
  /// - Returns: A StateSignal in order to set when subscribing a Store.
  public func createSignal<T: Equatable>(
    _ source: @escaping ((ApplicationStateType) -> T)
  ) -> StateSignal<T, ApplicationStateType> {
    let defaultValue: T = source(self.applicationState)
    return StateSignal<T, ApplicationStateType>(defaultValue, source: source)
  }

  /// Subscribes in order to detect dispatchings and value changed using StateSignals. To avoid memory leaks, unsubscribe when
  /// detection become unnecessary, but you don't need to unsubscribe set StateSignals directly.
  ///
  /// ```swift
  /// store.subscribe(self, connectTo: [userNameSignal, userAgeSignal]) // Two signals are set.
  /// userNameSignal.subscribe(self, didChange: { (_) in ... }) // You can subscribe the signals.
  /// ...
  /// store.unsubscribe(self) // The two signals are unsubscribed automatically.
  /// userNameSignal.unsubscribe(self) // This is not needed.
  /// ```
  ///
  /// - Parameters:
  ///   - subscriber: Class or object in order to distinguish who has signals.
  ///   - didChangeHandler: This closure is called every time after an Action is dispatched (optional).
  ///   - signals: Target StateSignals in order to set values from Application State automatically. These signals are
  ///              unsubscribed when `store.unsubscribe(_:)` is called.
  public func subscribe(
    _ subscriber: AnyObject,
    didChange didChangeHandler: @escaping DidChangeHandler = { (_) in },
    connectTo signals: [StateSignalType]
  ) {
    self.subscribe(subscriber, didChange: didChangeHandler)

    let subscriberId: StoreSubscriberId = self.getSubscriberId(of: subscriber)
    StateSignalManager.shared.register(signals: signals, of: subscriberId)

    // Set a handler.
    self.setDidDispatchHandler(id: Store.handlerId, handler: { (newState: ApplicationStateType, _, _) in
      StateSignalManager.shared.inputAll(state: newState)
    })
    let uniqueHandlerIdWithSubscriberId: HandlerId = "\(Store.handlerId)#\(String(subscriberId.hashValue))"
    self.setDidUnsubscribeHandler(id: uniqueHandlerIdWithSubscriberId, handler: { (id: StoreSubscriberId) in
      if subscriberId != id { return }

      StateSignalManager.shared.removeSignals(of: subscriberId)
    })
  }

}
