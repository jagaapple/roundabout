// =============================================================================================================================
// DEMO - VIEWS - MAIN - MAIN TABLE VIEW CONTROLLER
// =============================================================================================================================
import UIKit

final class MainTableViewController: UITableViewController {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define private variables.
  private var books: [BookModel] = []
  private var selectedBookIndex: Int?


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Overrides
  // ---------------------------------------------------------------------------------------------------------------------------
  override func viewDidLoad() {
    super.viewDidLoad()

    // Subscribe Store.
    ApplicationStore.shared.subscribe(self, didChange: self.bindToAppearance)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    // Unsubscribe Store to avoid memory leaks.
    ApplicationStore.shared.unsubscribe(self)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case let viewController as BooksEditViewController:
      viewController.prepare(book: nil)
    case let viewController as BooksDetailTableViewController:
      guard let selectedBookIndex: Int = self.selectedBookIndex else { return }

      let selectedBook: BookModel = self.books[selectedBookIndex]
      viewController.prepare(book: selectedBook)
    default: return
    }
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.books.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: MainDefaultTableViewCell = tableView.dequeueReusableCell(
      withIdentifier: MainDefaultTableViewCell.identifier,
      for: indexPath
    ) as? MainDefaultTableViewCell else { return UITableViewCell() }

    let book: BookModel = self.books[indexPath.row]
    cell.prepare(book: book)

    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 56.0
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedBookIndex = indexPath.row
    self.performSegue(withIdentifier: "toBookDetail", sender: nil)
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func bindToAppearance(_ state: ApplicationState) {
    self.books = Array(state.book.books.values)

    // This may affect performance because re-render a table view every time when some State is changed.
    // You should implement an efficient re-rendering algorithm.
    self.tableView.reloadData()
  }

}
