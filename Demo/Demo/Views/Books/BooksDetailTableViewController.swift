// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS DETAIL TABLE VIEW CONTROLLER
// =============================================================================================================================
import UIKit

final class BooksDetailTableViewController: UITableViewController {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define enums.
  private enum Rows: Int {
    case summary
    case score
    case edit
  }

  // Define private variables.
  private var book: BookModel!


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Overrides
  // ---------------------------------------------------------------------------------------------------------------------------
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.destination {
    case let viewController as BooksEditViewController:
      viewController.prepare(book: self.book)
    default: return
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Subscribe Store.
    ApplicationStore.shared.subscribe(self, didChange: self.bindToAppearance)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Unsubscribe Store to avoid memory leaks.
    ApplicationStore.shared.unsubscribe(self)
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row: Rows = Rows(rawValue: indexPath.row) ?? Rows.summary

    switch row {
    case .summary:
      guard let cell: BooksDetailSummaryTableViewCell = tableView.dequeueReusableCell(
        withIdentifier: BooksDetailSummaryTableViewCell.identifier,
        for: indexPath
      ) as? BooksDetailSummaryTableViewCell else { return UITableViewCell() }
      
      cell.prepare(book: self.book)

      return cell
    case .score:
      guard let cell: BooksDetailScoreTableViewCell = tableView.dequeueReusableCell(
        withIdentifier: BooksDetailScoreTableViewCell.identifier,
        for: indexPath
      ) as? BooksDetailScoreTableViewCell else { return UITableViewCell() }

      cell.prepare(book: self.book)

      return cell
    case .edit:
      guard let cell: BooksDetailEditTableViewCell = tableView.dequeueReusableCell(
        withIdentifier: BooksDetailEditTableViewCell.identifier,
        for: indexPath
      ) as? BooksDetailEditTableViewCell else { return UITableViewCell() }

      return cell
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let row: Rows = Rows(rawValue: indexPath.row) ?? Rows.summary

    switch row {
    case .summary: return 416.0
    case .score: return 136.0
    case .edit: return 89.0
    }
  }

  // Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(book: BookModel) {
    self.book = book
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func bindToAppearance(_ state: ApplicationState) {
    self.book = state.book.books[self.book.id]

    // This may affect performance because re-render a table view every time when some State is changed.
    // You should implement an efficient re-rendering algorithm.
    self.tableView.reloadData()
  }

}
