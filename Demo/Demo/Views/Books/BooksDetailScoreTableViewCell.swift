// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS DETAIL SCORE TABLE VIEW CELL
// =============================================================================================================================
import UIKit
import Roundabout

final class BooksDetailScoreTableViewCell: UITableViewCell {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Variables
  static var identifier: String { return "score" }

  // MARK: Private Variables
  private var bookId: UUID!
  private var scoreSignal: StateSignal<Int, ApplicationState>? {
    willSet { self.scoreSignal?.unsubscribe(self) }
    didSet { self.scoreSignal?.subscribe(self, didChange: self.bindScoreToAppearance) }
  }

  // MARK: IBOutlet Variables
  @IBOutlet weak private var scoreLabel: UILabel!


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Initializers
  // ---------------------------------------------------------------------------------------------------------------------------
  deinit {
    self.scoreSignal = nil
  }

  // MARK: Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(bookId: UUID, scoreSignal: StateSignal<Int, ApplicationState>) {
    self.bookId = bookId
    self.scoreSignal = scoreSignal
  }

  // MARK: Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func bindScoreToAppearance(_ score: Int) {
    self.scoreLabel.text = String(score)
  }

  // MARK: IBActions
  // ---------------------------------------------------------------------------------------------------------------------------
  @IBAction private func didTapIncrementScoreButton(_ sender: UIButton) {
    ApplicationStore.shared.dispatch(action: IncrementBookScoreAction(id: self.bookId))
  }

  @IBAction private func didTapDecrementScoreButton(_ sender: UIButton) {
    ApplicationStore.shared.dispatch(action: DecrementBookScoreAction(id: self.bookId))
  }

}
