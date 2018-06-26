// =============================================================================================================================
// DEMO - DEMO
// =============================================================================================================================
//struct ApplicationState2: State {
//  static var defaultState: ApplicationState { return ApplicationState() }
//  var user: UserState = UserState()
//
//  static func handleAction(state: ApplicationState, action: Action) -> ApplicationState {
//    return ApplicationState(
//      user: UserState.handleAction(state: state.user, action: action)
//    )
//  }
//}

struct UserState: State {
  static var defaultState: UserState { return UserState() }
  var name: String?
  var age: Int?
  var token: String?
}

extension UserState {
  static func handleAction(state: UserState, action: Action) -> UserState {
    var nextState: UserState = state

    switch action {
    case let action as UpdateUserNameAction:
      nextState.name = action.name
    default: break
    }

    return nextState
  }
}

struct UpdateUserNameAction: Action {
  let name: String
}

struct ApplicationState: State {
  static var defaultState: ApplicationState { return self.init(user: UserState()) }

  static func handleAction(state: ApplicationState, action: Action) -> ApplicationState {
    return self.init(user: state.user)
  }

  let user: UserState
}

let store: Store<ApplicationState> = Store<ApplicationState>()

class Demo {
  func viewWillAppear() {
    store.subscribe(self)
  }

  func viewWillDisAppear() {
    store.unsubscribe(self)
  }

  func hoge() {
    store.dispatch(action: UpdateUserNameAction(name: "hoge"))
  }

}
