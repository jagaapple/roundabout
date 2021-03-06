// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS INDEX TABLE VIEW CONTROLLER
// =============================================================================================================================
import UIKit

final class BooksIndexTableViewController: UITableViewController {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Private Variables
  private var books: [BookModel] = []
  private var selectedBookIndex: Int?


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Overrides
  // ---------------------------------------------------------------------------------------------------------------------------
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Subscribe a Store.
    ApplicationStore.shared.subscribe(self, didChange: self.bindToAppearance)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Unsubscribe a Store to avoid memory leaks.
    ApplicationStore.shared.unsubscribe(self)
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case let viewController as BooksEditViewController:
      viewController.prepare(book: nil)
    case let viewController as BooksDetailTableViewController:
      guard let selectedBookIndex = self.selectedBookIndex else { return }

      let selectedBook = self.books[selectedBookIndex]
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
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: BooksIndexDefaultTableViewCell.identifier,
      for: indexPath
    ) as? BooksIndexDefaultTableViewCell else { return UITableViewCell() }

    let book = self.books[indexPath.row]
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

  // MARK: Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func bindToAppearance(_ state: ApplicationState) {
    self.books = Array(state.book.books.values)

    // This may affect performance because re-render a table view every time after an Action is dispatched.
    // You should implement an efficient re-rendering algorithm.
    self.tableView.reloadData()
  }

}
