// =============================================================================================================================
// ROUNDABOUT SPEC - SAMPLE CLASSES - REDUX - MODELS - USER - USER STATE
// =============================================================================================================================
import Roundabout

struct UserState: State {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define internal variables.
  static var defaultState: UserState { return UserState() }
  var name: String?
  var age: Int = 0


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  static func handleAction(state: UserState, action: Action) -> UserState {
    var nextState: UserState = state

    switch action {
    case let action as UpdateUserFieldAction:
      nextState.name = action.name
      nextState.age = action.age
    case _ as IncrementUserAgeAction:
      nextState.age += 1
    case _ as DecrementUserAgeAction:
      nextState.age -= 1
    default: break
    }

    return nextState
  }

}
