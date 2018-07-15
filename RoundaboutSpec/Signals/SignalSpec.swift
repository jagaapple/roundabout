// =============================================================================================================================
// ROUNDABOUT SPEC - SIGNALS - SIGNAL SPEC
// =============================================================================================================================
import Roundabout
import Quick
import Nimble

final class SignalSpec: QuickSpec {
  override func spec() {
    var signal: Signal<Int>!
    var optionalSignal: Signal<Int?>!

    // -------------------------------------------------------------------------------------------------------------------------
    // MARK: - Subscribe with DidChangeHandler
    // -------------------------------------------------------------------------------------------------------------------------
    describe("SUBSCRIBE WITH DID CHANGE HANDLER ::") {
      var handlerCallCount: Int = 0
      beforeEach {
        signal = Signal<Int>(0)
        optionalSignal = Signal<Int?>(0)
        handlerCallCount = 0
      }
      afterEach {
        signal.unsubscribe(self)
        optionalSignal.unsubscribe(self)
      }

      context("when subscribing from a class with a handler,") {
        beforeEach { signal.subscribe(self, didChange: { (_) in handlerCallCount += 1 }) }

        it("should call the handler only once after subscribing") {
          expect(handlerCallCount).to(equal(1))
        }
      }

      context("when a raw value is set and changed,") {
        context("already subscribing,") {
          context("the value is changed to not nil") {
            beforeEach {
              signal.subscribe(self, didChange: { (_) in handlerCallCount += 1 })
              signal.rawValue = 1
            }

            it("should call the handler only once") {
              expect(handlerCallCount).to(equal(2))
            }
          }

          context("the value is changed to nil") {
            beforeEach {
              optionalSignal.subscribe(self, didChange: { (_) in handlerCallCount += 1 })
              optionalSignal.rawValue = nil
            }

            it("should call the handler only once") {
              expect(handlerCallCount).to(equal(2))
            }
          }
        }

        context("not subscribing,") {
          it("should not call the handler") {
            expect(handlerCallCount).to(equal(0))
          }
        }
      }

      context("when a raw value is set and not changed,") {
        context("already subscribing,") {
          context("the value is changed to not nil") {
            beforeEach {
              signal.subscribe(self, didChange: { (_) in handlerCallCount += 1 })
              signal.rawValue = signal.rawValue
            }

            it("should call the handler only once") {
              expect(handlerCallCount).to(equal(1))
            }
          }

          context("the value is changed to nil") {
            beforeEach {
              optionalSignal.subscribe(self, didChange: { (_) in handlerCallCount += 1 })
              optionalSignal.rawValue = optionalSignal.rawValue
            }

            it("should call the handler only once") {
              expect(handlerCallCount).to(equal(1))
            }
          }
        }

        context("not subscribing,") {
          it("should not call the handler") {
            expect(handlerCallCount).to(equal(0))
          }
        }
      }
    }

  }
}
