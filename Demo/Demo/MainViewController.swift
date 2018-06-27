// =============================================================================================================================
// DEMO - VIEW CONTROLLER
// =============================================================================================================================
import UIKit
import Roundabout

final class MainViewController: UIViewController {
  @IBOutlet weak private var accountAgeLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    // You should subscribe Store to observe some State changed.
    // Give a callback function to the second argument, it will be called every time when some States are changed.
    ApplicationStore.shared.subscribe(self, didChange: { (state: ApplicationState) in
      self.accountAgeLabel.text = String(state.account.age)
    })
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    // Don't forget to unsubscribe Store to prevent memory leaks.
    ApplicationStore.shared.unsubscribe(self)
  }

  @IBAction private func didTapAccountAgeIncrementButton(_ sender: UIButton) {
    // Dispatch an Action to increment the value.
    ApplicationStore.shared.dispatch(action: IncrementAccountAgeAction())
  }

  @IBAction private func didTapAccountAgeDecrementButton(_ sender: UIButton) {
    // Dispatch an Action to increment the value.
    ApplicationStore.shared.dispatch(action: DecrementAccountAgeAction())
  }

}
