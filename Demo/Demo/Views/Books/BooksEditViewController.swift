// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS EDIT VIEW CONTROLLER
// =============================================================================================================================
import UIKit
import Roundabout

final class BooksEditViewController: UIViewController {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define internal variables.
  var bookId: UUID?
  var bookTitle: String = ""
  var bookDescription: String?

  // Define private variables.
  private var isAddingMode: Bool { return (self.bookId == nil) }

  // Define IBOutlet variables.
  @IBOutlet weak var navigationBarSaveButton: UIButton!
  @IBOutlet weak private var navigationBarTitleLabel: UILabel!
  @IBOutlet weak private var tableView: UITableView!


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Overrides
  // ---------------------------------------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()

    self.bindToAppearance()
  }

  // Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(book: BookModel?) {
    if let book: BookModel = book {
      self.bookId = book.id
      self.bookTitle = book.title
      self.bookDescription = book.description
    }
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func bindToAppearance() {
    let title: String = (self.isAddingMode) ? "Add Book" : "Edit Book"
    self.navigationBarSaveButton.isEnabled = !self.bookTitle.isEmpty
    self.navigationBarTitleLabel.text = title
  }

  // IBActions
  // ---------------------------------------------------------------------------------------------------------------------------
  @IBAction private func didTapNavigationBarCancelButton(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

  @IBAction private func didTapNavigationBarSaveButton(_ sender: UIButton) {
    if self.bookTitle.isEmpty { return }

    // Create an Action.
    // In original Redux (JavaScript version), should create an Action using Action Creator before dispatch Action to Store,
    // but in Roundabout, it uses Struct in Swift as Action. Struct has an initializer to set values to itself properties, so
    // Action Creator is equal to an initializer of Struct in Roundabout.
    var action: Action!
    if self.isAddingMode {
      action = CreateBookAction(title: self.bookTitle, description: self.bookDescription)
    } else {
      action = UpdateBookBasicFieldAction(id: self.bookId!, title: self.bookTitle, description: self.bookDescription)
    }

    // Dispatch an Action to Store.
    ApplicationStore.shared.dispatch(action: action)

    self.dismiss(animated: true, completion: nil)
   }

}
