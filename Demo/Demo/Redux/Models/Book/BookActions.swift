// =============================================================================================================================
// DEMO - REDUX - MODELS - BOOK - BOOK ACTIONS
// =============================================================================================================================
import Roundabout

// Define Actions related to this model
// -----------------------------------------------------------------------------------------------------------------------------
// Creates some structs as Action in global scope in this case, but you can create them in a State using `extension` keyword.
//
// Example:
//   extension BookState {
//     struct UpdateBookBasicFieldAction: Action { ... }
//     ...
//   }

struct CreateBookAction: Action {
  let title: String
  let description: String?
}

struct UpdateBookBasicFieldAction: Action {
  let id: UUID
  let title: String
  let description: String?
}

struct IncrementBookScoreAction: Action {
  let id: UUID
}

struct DecrementBookScoreAction: Action {
  let id: UUID
}
