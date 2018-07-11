// =============================================================================================================================
// DEMO - REDUX - MODELS - BOOK - BOOK STATE
// =============================================================================================================================
import Roundabout

struct BookState: State {

  // 1. Define this State properties
  // ---------------------------------------------------------------------------------------------------------------------------
  var books: [UUID: BookModel] = [:]


  // 2. Define a getter to return default property values of this State
  // ---------------------------------------------------------------------------------------------------------------------------
  // This will be called when this State does not exist in a Store.
  static var defaultState: BookState { return BookState() }


  // 3. Define a Reducer for this State
  // ---------------------------------------------------------------------------------------------------------------------------
  // In generally, we should update this State using only Actions related to itself.
  // The new State returned by this function will be stored, in other words this (old) State will be overwritten by the new
  // State, so you must return current this State when receiving Actions not related to this.
  static func handleAction(state: BookState, action: Action) -> BookState {
    var nextState = state

    switch action {
    case let action as CreateBookAction:
      let newId = UUID()
      let newBook = BookModel(id: newId, title: action.title, description: action.description, score: 0)
      nextState.books[newId] = newBook
    case let action as UpdateBookBasicFieldAction:
      nextState.books[action.id]?.title = action.title
      nextState.books[action.id]?.description = action.description
    case let action as IncrementBookScoreAction:
      nextState.books[action.id]?.score += 1
    case let action as DecrementBookScoreAction:
      if nextState.books[action.id]?.score == 0 { break }
      nextState.books[action.id]?.score -= 1
    default: break
    }

    return nextState
  }

}
