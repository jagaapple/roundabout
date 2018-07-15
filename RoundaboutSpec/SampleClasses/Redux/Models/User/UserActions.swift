// =============================================================================================================================
// ROUNDABOUT SPEC - SAMPLE CLASSES - REDUX - MODELS - USER - USER ACTIONS
// =============================================================================================================================
import Roundabout

struct UpdateUserFieldAction: Action {
  let name: String
  let age: Int
}

struct IncrementUserAgeAction: Action {}

struct DecrementUserAgeAction: Action {}
