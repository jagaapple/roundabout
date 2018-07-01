// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS INDEX DEFAULT TABLE VIEW CELL
// =============================================================================================================================
import UIKit

final class BooksIndexDefaultTableViewCell: UITableViewCell {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define internal variables.
  static var identifier: String { return "default" }

  // Define private variables.
  @IBOutlet weak private var titleLabel: UILabel!
  @IBOutlet weak private var descriptionLabel: UILabel!
  private var book: BookModel!


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(book: BookModel) {
    self.book = book

    self.bindToAppearance()
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func bindToAppearance() {
    self.titleLabel.text = self.book.title
    self.descriptionLabel.text = self.book.description

    if (self.book.description == nil) || self.book.description!.isEmpty {
      self.descriptionLabel.text = "No Description."
      self.descriptionLabel.alpha = 0.5
    } else {
      self.descriptionLabel.alpha = 1.0
    }
  }

}
