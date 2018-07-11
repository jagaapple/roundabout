// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS DETAIL SCORE TABLE VIEW CELL
// =============================================================================================================================
import UIKit

final class BooksDetailScoreTableViewCell: UITableViewCell {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Variables
  static var identifier: String { return "score" }

  // MARK: Private Variables
  private var book: BookModel!

  // MARK: IBOutlet Variables
  @IBOutlet weak private var scoreLabel: UILabel!


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(book: BookModel) {
    self.book = book

    self.bindToAppearance(book: book)
  }

  // MARK: Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func bindToAppearance(book: BookModel) {
    self.scoreLabel.text = String(book.score)
  }

  // MARK: IBActions
  // ---------------------------------------------------------------------------------------------------------------------------
  @IBAction private func didTapIncrementScoreButton(_ sender: UIButton) {
    ApplicationStore.shared.dispatch(action: IncrementBookScoreAction(id: self.book.id))
  }

  @IBAction private func didTapDecrementScoreButton(_ sender: UIButton) {
    ApplicationStore.shared.dispatch(action: DecrementBookScoreAction(id: self.book.id))
  }

}
