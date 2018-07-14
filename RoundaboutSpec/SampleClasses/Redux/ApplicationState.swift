// =============================================================================================================================
// ROUNDABOUT SPEC - SAMPLE CLASSES - REDUX - APPLICATION STATE
// =============================================================================================================================
import Roundabout

struct ApplicationState: State {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define internal variables.
  static var defaultState: ApplicationState { return ApplicationState() }
  static var didReduceHandler: ((Any, Any) -> Void)?
  var user: UserState = UserState.defaultState


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  static func handleAction(state: ApplicationState, action: Action) -> ApplicationState {
    ApplicationState.didReduceHandler?(state, action)

    return ApplicationState(
      user: UserState.handleAction(state: state.user, action: action)
    )
  }

}
