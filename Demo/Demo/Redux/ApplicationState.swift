// =============================================================================================================================
// DEMO - REDUX - APPLICATION STATE
// =============================================================================================================================
import Roundabout

// Define State to give to Store.
// ApplicationState defined in this should be a parent for some States. Most of applications will requires multiple States, so
// you would need this approach.
struct ApplicationState: State {

  static var defaultState: ApplicationState { return ApplicationState() }

  // These are child States.
  var account: AccountState = AccountState.defaultState

  // Define Reducer behavior for this State.
  // ApplicationState has some States, should call reducers of them and update itself.
  static func handleAction(state: ApplicationState, action: Action) -> ApplicationState {
    return ApplicationState(
      account: AccountState.handleAction(state: state.account, action: action)
    )
  }

}
