// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS EDIT VIEW CONTROLLER
// =============================================================================================================================
import UIKit
import Roundabout

final class BooksEditViewController: UIViewController {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Variables
  var bookId: UUID?
  var bookTitle = ""
  var bookDescription: String?

  // MARK: Private Variables
  private var isAddingMode: Bool { return (self.bookId == nil) }

  // MARK: IBOutlet Variables
  @IBOutlet weak var navigationBarSaveButton: UIButton!
  @IBOutlet weak private var navigationBarTitleLabel: UILabel!
  @IBOutlet weak private var tableView: UITableView!


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Overrides
  // ---------------------------------------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()

    self.bindToAppearance()
  }

  // MARK: Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(book: BookModel?) {
    if let book = book {
      self.bookId = book.id
      self.bookTitle = book.title
      self.bookDescription = book.description
    }
  }

  // MARK: Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func bindToAppearance() {
    let title = (self.isAddingMode) ? "Add Book" : "Edit Book"
    self.navigationBarSaveButton.isEnabled = !self.bookTitle.isEmpty
    self.navigationBarTitleLabel.text = title
  }

  // MARK: IBActions
  // ---------------------------------------------------------------------------------------------------------------------------
  @IBAction private func didTapNavigationBarCancelButton(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

  @IBAction private func didTapNavigationBarSaveButton(_ sender: UIButton) {
    if self.bookTitle.isEmpty { return }

    // Create an Action.
    // In original Redux (JavaScript version), we should create an Action using Action Creator before dispatch the Action to a
    // Store, but in Roundabout, it uses Struct in Swift as Action. Struct has an initializer to set values to itself
    // properties, so Action Creator is equal to an initializer of Struct in Roundabout.
    var action: Action!
    if self.isAddingMode {
      action = CreateBookAction(title: self.bookTitle, description: self.bookDescription)
    } else {
      action = UpdateBookBasicFieldAction(id: self.bookId!, title: self.bookTitle, description: self.bookDescription)
    }

    // Dispatch an Action to a Store.
    ApplicationStore.shared.dispatch(action: action)

    self.dismiss(animated: true, completion: nil)
   }

}
