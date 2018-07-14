// =============================================================================================================================
// ROUNDABOUT SPEC - CORE TYPES - STORE SPEC
// =============================================================================================================================
import Roundabout
import Quick
import Nimble

final class StoreSpec: QuickSpec {
  override func spec() {
    var store: Store<ApplicationState>!

    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Subscribe with DidChangeHandler
    // -------------------------------------------------------------------------------------------------------------------------
    describe("SUBSCRIBE WITH DID CHANGE HANDLER ::") {
      var handlerCallCount: Int = 0
      beforeEach {
        handlerCallCount = 0

        store = Store<ApplicationState>()
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
        handlerCallCount = 0

        store = Store<ApplicationState>()
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

        it("should call Application State's Reducer") {
          expect(reducerCallCount).to(equal(1))
        }

        it("should pass Application State and the Action to Application State's Reducer") {
          expect(hasState).to(beTrue())
          expect(hasAction).to(beTrue())
          expect(isTheAction).to(beTrue())
        }
      }
    }


    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Set Will Dispatch Handler
    // -------------------------------------------------------------------------------------------------------------------------
    describe("SET WILL DISPATCH HANDLER ::") {
      let action: Action = IncrementUserAgeAction()
      let id: String = "id"
      var handlerCallCount: Int = 0
      var hasState: Bool = false
      var hasAction: Bool = false
      var isTheAction: Bool = false
      var userAge: Int?
      beforeEach {
        handlerCallCount = 0
        hasState = false
        hasAction = false
        isTheAction = false
        userAge = false

        store = Store<ApplicationState>()
      }

      context("when setting a handler with an unique ID,") {
        beforeEach {
          store.setWillDispatchHandler(id: id, handler: { (state: Any, action: Any) in
            handlerCallCount += 1
            hasState = state is ApplicationState
            hasAction = action is Action
            isTheAction = action is IncrementUserAgeAction
            userAge = (state as? ApplicationState)?.user.age
          })
        }
        afterEach { store.removeWillDispatchHandler(id: id) }

        context("dispatching an Action,") {
          beforeEach { store.dispatch(action: action) }

          it("should call the handler") {
            expect(handlerCallCount).to(equal(1))
          }

          it("should pass the current Application State and the Action to the handler") {
            expect(hasState).to(beTrue())
            expect(hasAction).to(beTrue())
            expect(isTheAction).to(beTrue())
            expect(userAge).to(equal(0))
          }
        }
      }

      context("when setting a handler with the ID used already") {
        var secondHandlerCallCount: Int = 0
        beforeEach {
          secondHandlerCallCount = 0

          store.setWillDispatchHandler(id: id, handler: { (_, _) in handlerCallCount += 1 })
          store.setWillDispatchHandler(id: id, handler: { (_, _) in secondHandlerCallCount += 1 })
        }
        afterEach { store.removeWillDispatchHandler(id: id) }

        context("dispatching an Action,") {
          beforeEach { store.dispatch(action: action) }

          it("should not call the handler") {
            expect(handlerCallCount).to(equal(1))
            expect(secondHandlerCallCount).to(equal(0))
          }
        }
      }
    }


    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Remove Will Dispatch Handler
    // -------------------------------------------------------------------------------------------------------------------------
    describe("REMOVE WILL DISPATCH HANDLER ::") {
      let action: Action = IncrementUserAgeAction()
      let id: String = "id"
      var handlerCallCount: Int = 0
      beforeEach {
        handlerCallCount = 0

        store = Store<ApplicationState>()
        store.setWillDispatchHandler(id: id, handler: { (_, _) in handlerCallCount += 1 })
      }
      afterEach { store.removeWillDispatchHandler(id: id) }

      context("when removing with an ID after setting a handler with the ID,") {
        beforeEach { store.removeWillDispatchHandler(id: id) }

        context("when dispatching an Action,") {
          beforeEach { store.dispatch(action: action) }

          it("should not call the handler") {
            expect(handlerCallCount).to(equal(0))
          }
        }
      }

      context("when not removing with an ID after setting a handler with another ID,") {
        beforeEach { store.removeWillDispatchHandler(id: "dummy") }

        context("when dispatching an Action,") {
          beforeEach { store.dispatch(action: action) }

          it("should call the handler") {
            expect(handlerCallCount).to(equal(1))
          }
        }
      }
    }


    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Set Did Dispatch Handler
    // -------------------------------------------------------------------------------------------------------------------------
    describe("SET DID DISPATCH HANDLER ::") {
      let action: Action = IncrementUserAgeAction()
      let id: String = "id"
      var handlerCallCount: Int = 0
      var hasNewState: Bool = false
      var hasOldState: Bool = false
      var hasAction: Bool = false
      var isTheAction: Bool = false
      beforeEach {
        handlerCallCount = 0
        hasNewState = false
        hasOldState = false
        hasAction = false
        isTheAction = false

        store = Store<ApplicationState>()
      }

      context("when setting a handler with an unique ID,") {
        beforeEach {
          store.setDidDispatchHandler(id: id, handler: { (newState: Any, action: Any, oldState: Any) in
            handlerCallCount += 1
            hasNewState = (newState is ApplicationState) && ((newState as? ApplicationState)?.user.age == 1)
            hasOldState = (oldState is ApplicationState) && ((oldState as? ApplicationState)?.user.age == 0)
            hasAction = action is Action
            isTheAction = action is IncrementUserAgeAction
          })
        }
        afterEach { store.removeDidDispatchHandler(id: id) }

        context("dispatching an Action,") {
          beforeEach { store.dispatch(action: action) }

          it("should call the handler") {
            expect(handlerCallCount).to(equal(1))
          }

          it("should pass a new and old Application State and the Action to the handler") {
            expect(hasNewState).to(beTrue())
            expect(hasOldState).to(beTrue())
            expect(hasAction).to(beTrue())
            expect(isTheAction).to(beTrue())
          }
        }
      }

      context("when setting a handler with the ID used already") {
        var secondHandlerCallCount: Int = 0
        beforeEach {
          secondHandlerCallCount = 0

          store.setDidDispatchHandler(id: id, handler: { (_, _, _) in handlerCallCount += 1 })
          store.setDidDispatchHandler(id: id, handler: { (_, _, _) in secondHandlerCallCount += 1 })
        }
        afterEach { store.removeDidDispatchHandler(id: id) }

        context("dispatching an Action,") {
          beforeEach { store.dispatch(action: action) }

          it("should not call the handler") {
            expect(handlerCallCount).to(equal(1))
            expect(secondHandlerCallCount).to(equal(0))
          }
        }
      }
    }


    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Remove Did Dispatch Handler
    // -------------------------------------------------------------------------------------------------------------------------
    describe("REMOVE DID DISPATCH HANDLER ::") {
      let action: Action = IncrementUserAgeAction()
      let id: String = "id"
      var handlerCallCount: Int = 0
      beforeEach {
        handlerCallCount = 0

        store = Store<ApplicationState>()
        store.setDidDispatchHandler(id: id, handler: { (_, _, _) in handlerCallCount += 1 })
      }
      afterEach { store.removeDidDispatchHandler(id: id) }

      context("when removing with an ID after setting a handler with the ID,") {
        beforeEach { store.removeDidDispatchHandler(id: id) }

        context("when dispatching an Action,") {
          beforeEach { store.dispatch(action: action) }

          it("should not call the handler") {
            expect(handlerCallCount).to(equal(0))
          }
        }
      }

      context("when not removing with an ID after setting a handler with another ID,") {
        beforeEach { store.removeDidDispatchHandler(id: "dummy") }

        context("when dispatching an Action,") {
          beforeEach { store.dispatch(action: action) }

          it("should call the handler") {
            expect(handlerCallCount).to(equal(1))
          }
        }
      }
    }

  }
}
