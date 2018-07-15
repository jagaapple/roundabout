// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS DETAIL SUMMARY TABLE VIEW CELL
// =============================================================================================================================
import UIKit

final class BooksDetailSummaryTableViewCell: UITableViewCell {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Variables
  static var identifier: String { return "summary" }

  // MARK: IBOutlet Variables
  @IBOutlet weak private var titleLabel: UILabel!
  @IBOutlet weak private var descriptionLabel: UILabel!


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(book: BookModel) {
    self.bindToAppearance(book: book)
  }

  // MARK: Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func bindToAppearance(book: BookModel) {
    self.titleLabel.text = book.title
    self.descriptionLabel.text = book.description
  }

}
