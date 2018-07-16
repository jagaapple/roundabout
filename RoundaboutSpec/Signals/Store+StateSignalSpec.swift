// =============================================================================================================================
// ROUNDABOUT SPEC - SIGNALS - STORE + STATE SIGNAL SPEC
// =============================================================================================================================
import Roundabout
import Quick
import Nimble

final class StoreExtensionStateSignalSpec: QuickSpec {
  override func spec() {
    var store: Store<ApplicationState>!
    beforeEach { store = Store<ApplicationState>() }

    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Create Signal
    // -------------------------------------------------------------------------------------------------------------------------
    describe("CREATE SIGNAL ::") {
      var userAgeSignal: StateSignal<Int, ApplicationState>!
      beforeEach {
        userAgeSignal = store.createSignal { $0.user.age }

        store.subscribe(self, connectTo: [userAgeSignal])
      }

      it("should return StateSignal with returned value by closure as a default value") {
        expect(userAgeSignal.rawValue).to(equal(0))
      }
    }


    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Subscribe with State Signals
    // -------------------------------------------------------------------------------------------------------------------------
    describe("SUBSCRIBE WITH STATE SIGNALS ::") {
      var userNameSignal: StateSignal<String?, ApplicationState>!
      var userNameSignalHandlerCallCount: Int = 0
      var userAgeSignal: StateSignal<Int, ApplicationState>!
      var userAgeSignalHandlerCallCount: Int = 0
      beforeEach {
        userNameSignal = store.createSignal { $0.user.name }
        userNameSignalHandlerCallCount = 0
        userAgeSignal = store.createSignal { $0.user.age }
        userAgeSignalHandlerCallCount = 0

        store.subscribe(self, connectTo: [userNameSignal, userAgeSignal])
      }
      afterEach { store.unsubscribe(self) }

      context("when subscribing a Store,") {
        it("should call State Signal's handlers") {
          expect(userNameSignalHandlerCallCount).to(equal(0))
          expect(userAgeSignalHandlerCallCount).to(equal(0))
        }
      }

      context("when subscribing a Store and State Signals,") {
        var userName: String?
        var userAge: Int = 0
        beforeEach {
          userName = nil
          userAge = 0

          userNameSignal.subscribe(self, didChange: { (name: String?) in
            userNameSignalHandlerCallCount += 1
            userName = name
          })
          userAgeSignal.subscribe(self, didChange: { (age: Int) in
            userAgeSignalHandlerCallCount += 1
            userAge = age
          })
        }

        it("should call State Signal's handlers only once after subscribing the State Signals") {
          expect(userNameSignalHandlerCallCount).to(equal(1))
          expect(userAgeSignalHandlerCallCount).to(equal(1))
        }

        context("dispatching some Actions,") {
          let expectedUserName: String = "dummy"
          let expectedUserAge: Int = 10
          beforeEach {
            let action: UpdateUserFieldAction = UpdateUserFieldAction(name: expectedUserName, age: expectedUserAge)
            store.dispatch(action: action)
          }

          it("should call Signal's handlers") {
            expect(userNameSignalHandlerCallCount).to(equal(2))
            expect(userAgeSignalHandlerCallCount).to(equal(2))
          }

          it("should pass a specific State value") {
            expect(userName).to(equal(expectedUserName))
            expect(userNameSignal.rawValue).to(equal(expectedUserName))
            expect(userAge).to(equal(expectedUserAge))
            expect(userAgeSignal.rawValue).to(equal(expectedUserAge))
          }
        }

        context("dispatching some Actions twice or more,") {
          let expectedUserName: String = "dummy"
          let expectedUserAge: Int = 10
          beforeEach {
            let action: UpdateUserFieldAction = UpdateUserFieldAction(name: expectedUserName, age: expectedUserAge)
            store.dispatch(action: action)
            store.dispatch(action: action)
          }

          it("should call Signal's handlers only once (excluding counts when suscribing State Signals)") {
            expect(userNameSignalHandlerCallCount).to(equal(2))
            expect(userAgeSignalHandlerCallCount).to(equal(2))
          }
        }
      }

      context("when unsubscribing a Store subscribed with some State Signals,") {
        beforeEach {
          userNameSignal.subscribe(self, didChange: { (_) in userNameSignalHandlerCallCount += 1 })
          userAgeSignal.subscribe(self, didChange: { (_) in userAgeSignalHandlerCallCount += 1 })
          store.unsubscribe(self)
        }

        context("dispatching some Actions after the unsubscribing,") {
          beforeEach {
            let action: UpdateUserFieldAction = UpdateUserFieldAction(name: "dummy", age: 10)
            store.dispatch(action: action)
          }

          it("should not call State Signal's handlers") {
            expect(userNameSignalHandlerCallCount).to(equal(1))
            expect(userAgeSignalHandlerCallCount).to(equal(1))
          }
        }
      }
    }


    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Subscribe with DidChangeHandler and State Signals
    // -------------------------------------------------------------------------------------------------------------------------
    describe("SUBSCRIBE WITH DID CHANGE HANDLER AND STATE SIGNALS ::") {
      var storeHandlerCallCount: Int = 0
      var userAgeSignal: StateSignal<Int, ApplicationState>!
      var userAgeSignalHandlerCallCount: Int = 0
      beforeEach {
        storeHandlerCallCount = 0
        userAgeSignal = store.createSignal { $0.user.age }
        userAgeSignalHandlerCallCount = 0

        store.subscribe(self, didChange: { (_) in storeHandlerCallCount += 1 }, connectTo: [userAgeSignal])
      }
      afterEach { store.unsubscribe(self) }

      context("when subscribing a Store,") {
        it("should call Store's handlers only once after subscribing") {
          expect(storeHandlerCallCount).to(equal(1))
        }

        it("should not call State Signal's handlers") {
          expect(userAgeSignalHandlerCallCount).to(equal(0))
        }
      }

      context("when subscribing a Store and State Signals,") {
        beforeEach {
          userAgeSignal.subscribe(self, didChange: { (_) in userAgeSignalHandlerCallCount += 1 })
        }

        it("should call Store's handlers only once after subscribing the Store") {
          expect(storeHandlerCallCount).to(equal(1))
        }

        it("should call State Signal's handlers only once after subscribing the State Signals") {
          expect(userAgeSignalHandlerCallCount).to(equal(1))
        }

        context("dispatching some Actions,") {
          let expectedUserAge: Int = 10
          beforeEach {
            let action: UpdateUserFieldAction = UpdateUserFieldAction(name: "dummy", age: expectedUserAge)
            store.dispatch(action: action)
          }

          it("should call Store's handlers") {
            expect(storeHandlerCallCount).to(equal(2))
          }

          it("should call Signal's handlers") {
            expect(userAgeSignalHandlerCallCount).to(equal(2))
          }
        }

        context("dispatching some Actions twice or more,") {
          let expectedUserAge: Int = 10
          beforeEach {
            let action: UpdateUserFieldAction = UpdateUserFieldAction(name: "dummy", age: expectedUserAge)
            store.dispatch(action: action)
            store.dispatch(action: action)
          }

          it("should call Store's handlers twice or more") {
            expect(storeHandlerCallCount).to(equal(3))
          }

          it("should call Signal's handlers only once (excluding counts when suscribing State Signals)") {
            expect(userAgeSignalHandlerCallCount).to(equal(2))
          }
        }
      }

      context("when unsubscribing a Store subscribed with some State Signals,") {
        beforeEach {
          userAgeSignal.subscribe(self, didChange: { (_) in userAgeSignalHandlerCallCount += 1 })
          store.unsubscribe(self)
        }

        context("dispatching some Actions after the unsubscribing,") {
          beforeEach {
            let action: UpdateUserFieldAction = UpdateUserFieldAction(name: "dummy", age: 10)
            store.dispatch(action: action)
          }

          it("should not call Store's handlers") {
            expect(storeHandlerCallCount).to(equal(1))
          }

          it("should not call State Signal's handlers") {
            expect(userAgeSignalHandlerCallCount).to(equal(1))
          }
        }
      }
    }

  }
}
