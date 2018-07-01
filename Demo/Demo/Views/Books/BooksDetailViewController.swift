// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS DETAIL VIEW CONTROLLER
// =============================================================================================================================
import UIKit

final class BooksDetailViewController: UIViewController {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define private variables.
  private var book: BookModel!


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.bindToAppearance()
  }

  // Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(book: BookModel) {
    self.book = book
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func bindToAppearance() {
    self.title = self.book.title
  }

}
