// =============================================================================================================================
// DEMO - REDUX - APPLICATION STATE
// =============================================================================================================================
import Roundabout

// Define a State to pass to a Store
// -----------------------------------------------------------------------------------------------------------------------------
// ApplicationState defined in this should be a parent for some States. Most of applications will requires multiple States, so
// you would need this approach.
struct ApplicationState: State {
  static var defaultState: ApplicationState { return ApplicationState() }

  // 1. Define child States
  // ---------------------------------------------------------------------------------------------------------------------------
  var book = BookState.defaultState

  
  // 2. Define a Reducer for this State
  // ---------------------------------------------------------------------------------------------------------------------------
  // ApplicationState has some States, we must call Reducers of them and update itself.
  static func handleAction(state: ApplicationState, action: Action) -> ApplicationState {
    return ApplicationState(
      book: BookState.handleAction(state: state.book, action: action)
    )
  }

}
