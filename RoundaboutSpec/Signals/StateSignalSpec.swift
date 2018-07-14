// =============================================================================================================================
// ROUNDABOUT SPEC - SIGNALS - STATE SIGNAL SPEC
// =============================================================================================================================
import Roundabout
import Quick
import Nimble

final class StateSignalSpec: QuickSpec {
  override func spec() {
    var stateSignal: StateSignal<Int, ApplicationState>!

    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Input
    // -------------------------------------------------------------------------------------------------------------------------
    describe("INPUT ::") {
      var handlerCallCount: Int = 0
      var userAge: Int = 0
      beforeEach {
        handlerCallCount = 0
        userAge = 0

        stateSignal = StateSignal<Int, ApplicationState>(0, source: { $0.user.age })
        stateSignal.subscribe(self, didChange: { (num: Int) in
          handlerCallCount += 1
          userAge = num
        })
      }
      afterEach { stateSignal.unsubscribe(self) }

      context("when passing Application State which has UserState having a specific age,") {
        var userState: UserState!
        var applicationState: ApplicationState!
        beforeEach {
          userState = UserState(name: nil, age: 10)
          applicationState = ApplicationState(user: userState)
          stateSignal.input(applicationState)
        }

        context("the age value is changed") {
          it("should call didChangeHandler with the value") {
            expect(handlerCallCount).to(equal(2))
            expect(userAge).to(equal(userState.age))
          }
        }

        context("the age value is not changed") {
          beforeEach {
            userState = UserState(name: nil, age: 10)
            applicationState = ApplicationState(user: userState)
            stateSignal.input(applicationState)
          }

          it("should not call") {
            expect(handlerCallCount).to(equal(2))
          }
        }
      }
    }

  }
}
