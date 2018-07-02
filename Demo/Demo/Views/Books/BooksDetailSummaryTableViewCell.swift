// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS DETAIL SUMMARY TABLE VIEW CELL
// =============================================================================================================================
import UIKit

final class BooksDetailSummaryTableViewCell: UITableViewCell {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define internal variables.
  static var identifier: String { return "summary" }

  // Define IBOutlet variables.
  @IBOutlet weak private var titleLabel: UILabel!
  @IBOutlet weak private var descriptionLabel: UILabel!


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(book: BookModel) {
    self.bindToAppearance(book: book)
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func bindToAppearance(book: BookModel) {
    self.titleLabel.text = book.title
    self.descriptionLabel.text = book.description
  }

}
