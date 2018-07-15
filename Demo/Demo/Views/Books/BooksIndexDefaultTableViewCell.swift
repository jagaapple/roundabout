// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS INDEX DEFAULT TABLE VIEW CELL
// =============================================================================================================================
import UIKit

final class BooksIndexDefaultTableViewCell: UITableViewCell {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Variables
  static var identifier: String { return "default" }

  // MARK: Private Variables
  @IBOutlet weak private var titleLabel: UILabel!
  @IBOutlet weak private var descriptionLabel: UILabel!
  @IBOutlet weak private var scoreLabel: UILabel!
  private var book: BookModel!


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(book: BookModel) {
    self.book = book

    self.bindToAppearance()
  }

  // MARK: Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func bindToAppearance() {
    self.titleLabel.text = self.book.title
    self.descriptionLabel.text = self.book.description
    self.scoreLabel.text = String(self.book.score)

    if (self.book.description == nil) || self.book.description!.isEmpty {
      self.descriptionLabel.text = "No Description."
      self.descriptionLabel.alpha = 0.5
    } else {
      self.descriptionLabel.alpha = 1.0
    }
  }

}
