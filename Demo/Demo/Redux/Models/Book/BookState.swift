// =============================================================================================================================
// DEMO - REDUX - MODELS - BOOK - BOOK STATE
// =============================================================================================================================
import Roundabout

struct BookState: State {

  // 1. Define this State properties
  // ---------------------------------------------------------------------------------------------------------------------------
  var books: [UUID: BookModel] = [:]


  // 2. Define getter to return default property values of this State
  // ---------------------------------------------------------------------------------------------------------------------------
  // It will be called when this State is never once stored in Store.
  static var defaultState: BookState { return BookState() }


  // 3. Define Reducer behavior for this State
  // ---------------------------------------------------------------------------------------------------------------------------
  // In generally, should update this State using only Actions related to itself.
  // The new State returned this function will be stored, in other words this State will be overwritten, so you should return
  // current this State when receiving Action not related to this.
  static func handleAction(state: BookState, action: Action) -> BookState {
    var nextState: BookState = state

    switch action {
    case let action as CreateBookAction:
      let newId: UUID = UUID()
      let newBook: BookModel = BookModel(id: newId, title: action.title, description: action.description, score: 0)
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
