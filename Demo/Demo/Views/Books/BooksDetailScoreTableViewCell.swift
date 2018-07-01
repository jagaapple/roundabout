// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS DETAIL SCORE TABLE VIEW CELL
// =============================================================================================================================
import UIKit

final class BooksDetailScoreTableViewCell: UITableViewCell {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define internal variables.
  static var identifier: String { return "score" }

  // Define private variables.
  private var book: BookModel!

  // Define IBOutlet variables.
  @IBOutlet weak private var scoreLabel: UILabel!


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(book: BookModel) {
    self.book = book

    self.bindToAppearance(book: book)
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func bindToAppearance(book: BookModel) {
    self.scoreLabel.text = String(book.score)
  }

  // IBActions
  // ---------------------------------------------------------------------------------------------------------------------------
  @IBAction private func didTapIncrementScoreButton(_ sender: UIButton) {
    ApplicationStore.shared.dispatch(action: IncrementBookScoreAction(id: self.book.id))
  }

  @IBAction private func didTapDecrementScoreButton(_ sender: UIButton) {
    ApplicationStore.shared.dispatch(action: DecrementBookScoreAction(id: self.book.id))
  }

}
