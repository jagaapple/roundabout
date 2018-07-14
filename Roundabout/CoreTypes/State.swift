// =============================================================================================================================
// ROUNDABOUT - CORE TYPES - STATE
// =============================================================================================================================
import Foundation

/// State is stored globally in a Store and it is read-only. When you want to change a State, you dispatch an Action to do.
public protocol State {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Variables
  /// This will be called when this State does not exist in a Store.
  static var defaultState: Self { get }


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  /// This function is Reducer. In generally, we should update this State using only Actions related to itself.
  ///
  /// - Parameters:
  ///   - state: The current this State.
  ///   - action: A dispatched Action.
  /// - Returns: A new State which will override an old this State.
  static func handleAction(state: Self, action: Action) -> Self

}
