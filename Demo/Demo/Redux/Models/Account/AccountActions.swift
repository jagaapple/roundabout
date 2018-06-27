// =============================================================================================================================
// DEMO - REDUX - MODELS - ACCOUNT - ACCOUNT ACTIONS
// =============================================================================================================================
import Roundabout

// Define Actions related to Account model.
// Create some struct as Action in global scope in this case, but you can create them in State using `extension` keyword.
//
// Example:
//   extension AccountState {
//     struct UpdateBasicFieldAction: Action { ... }
//     ...
//   }

struct UpdateAccountBasicFieldAction: Action {
  let id: Int
  let name: String
}

struct UpdateAccountProfileFieldAction: Action {
  let displayName: String
  let age: Int
}

struct IncrementAccountAgeAction: Action {}

struct DecrementAccountAgeAction: Action {}
