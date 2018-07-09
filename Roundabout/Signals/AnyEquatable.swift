// =============================================================================================================================
// ROUNDABOUT - SIGNALS - ANY EQUATABLE
// =============================================================================================================================
import Foundation

public struct AnyEquatable: Equatable {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define internal variables.
  let value: Any

  // Define private variables.
  fileprivate var didCompareHandler: ((Any) -> Bool)


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Initializers
  // ---------------------------------------------------------------------------------------------------------------------------
  public init<E: Equatable>(_ value: E) {
    self.value = value
    self.didCompareHandler = { (comparedValue: Any) -> Bool in
      if let comparedValue: E = comparedValue as? E { return (comparedValue == value) }
      return false
    }
  }
}

public func ==(lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
  return lhs.didCompareHandler(rhs.value)
}
