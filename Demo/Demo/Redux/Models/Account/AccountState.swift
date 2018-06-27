// =============================================================================================================================
// DEMO - REDUX - MODELS - ACCOUNT - ACCOUNT STATE
// =============================================================================================================================
import Roundabout

struct AccountState: State {

  // Define getter to return default property values of this State.
  // It will be called when this State is never once stored in Store.
  static var defaultState: AccountState { return AccountState() }

  // Define this state properties.
  var id: Int?
  var name: String?
  var displayName: String?
  var age: Int = 0

  // Define Reducer behavior for this State.
  // In generally, should update this State using only Actions related to itself.
  // The new State returned this function will be stored, in other words this State will be overwritten, so you should return
  // current this State when receiving Action not related to this.
  static func handleAction(state: AccountState, action: Action) -> AccountState {
    var nextState: AccountState = state

    switch action {
    case let action as UpdateAccountBasicFieldAction:
      nextState.id = action.id
      nextState.name = action.name
    case let action as UpdateAccountProfileFieldAction:
      nextState.displayName = action.displayName
      nextState.age = action.age
    case _ as IncrementAccountAgeAction:
      nextState.age = state.age + 1
    case _ as DecrementAccountAgeAction:
      nextState.age = state.age - 1
    default: break
    }

    return nextState
  }

}
