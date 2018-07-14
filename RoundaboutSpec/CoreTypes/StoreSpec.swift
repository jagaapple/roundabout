// =============================================================================================================================
// ROUNDABOUT SPEC - CORE TYPES - STORE SPEC
// =============================================================================================================================
import Roundabout
import Quick
import Nimble

class StoreSpec: QuickSpec {
  override func spec() {
    var store: Store<ApplicationState>!

    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Subscribe with DidChangeHandler
    // -------------------------------------------------------------------------------------------------------------------------
    describe("SUBSCRIBE WITH DID CHANGE HANDLER ::") {
      var handlerCallCount: Int = 0
      beforeEach {
        store = Store<ApplicationState>()
        handlerCallCount = 0
      }
      afterEach { store.unsubscribe(self) }

      context("when subscribing from a class with a handler,") {
        beforeEach { store.subscribe(self, didChange: { (_) in handlerCallCount += 1 }) }

        it("should call the handler at once after subscribing") {
          expect(handlerCallCount).to(equal(1))
        }
      }

      context("when an Action is dispatched,") {
        context("already subscribing,") {
          beforeEach {
            store.subscribe(self, didChange: { (_) in handlerCallCount += 1 })
            store.dispatch(action: IncrementUserAgeAction())
          }

          it("should call the handler at once") {
            expect(handlerCallCount).to(equal(2))
          }
        }

        context("not subscribing,") {
          it("should not call the handler") {
            expect(handlerCallCount).to(equal(0))
          }
        }
      }
    }


    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Unsubscribe
    // -------------------------------------------------------------------------------------------------------------------------
    describe("UNSUBSCRIBE ::") {
      var handlerCallCount: Int = 0
      beforeEach {
        store = Store<ApplicationState>()
        handlerCallCount = 0

        store.subscribe(self, didChange: { (_) in handlerCallCount += 1 })
      }

      context("when unsubscribing after subscribing,") {
        beforeEach { store.unsubscribe(self) }

        it("should not call the handler after unsubscribing") {
          expect(handlerCallCount).to(equal(1))
        }
      }

      context("when an Action is dispatched after unsubscribing,") {
        beforeEach {
          store.unsubscribe(self)
          store.dispatch(action: IncrementUserAgeAction())
        }

        it("should not call") {
          expect(handlerCallCount).to(equal(1))
        }
      }
    }


    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Dispatch
    // -------------------------------------------------------------------------------------------------------------------------
    describe("DISPATCH ::") {
      context("when dispatching an Action,") {
        let action: Action = IncrementUserAgeAction()
        var reducerCallCount: Int = 0
        var hasState: Bool = false
        var hasAction: Bool = false
        var isTheAction: Bool = false
        beforeEach {
          reducerCallCount = 0
          hasState = false
          hasAction = false
          isTheAction = false

          ApplicationState.didReduceHandler = { (state: Any, action: Any) in
            reducerCallCount += 1
            hasState = state is ApplicationState
            hasAction = action is Action
            isTheAction = action is IncrementUserAgeAction
          }
          store = Store<ApplicationState>()
          store.dispatch(action: action)
        }

        it("should call ApplicationState's Reducer") {
          expect(reducerCallCount).to(equal(1))
        }

        it("should pass ApplicationState and the Action to ApplicationState's Reducer") {
          expect(hasState).to(beTrue())
          expect(hasAction).to(beTrue())
          expect(isTheAction).to(beTrue())
        }
      }
    }

  }
}
