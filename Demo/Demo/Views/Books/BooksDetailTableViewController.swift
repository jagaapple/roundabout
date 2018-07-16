// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS DETAIL TABLE VIEW CONTROLLER
// =============================================================================================================================
import UIKit

final class BooksDetailTableViewController: UITableViewController {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Enums
  private enum Rows: Int {
    case summary
    case score
    case edit
  }

  // MARK: Private Variables
  private var book: BookModel!
  private lazy var bookTitleSignal = ApplicationStore.shared.createSignal { $0.book.books[self.book.id]?.title ?? "" }
  private lazy var bookDescriptionSignal = ApplicationStore.shared.createSignal { $0.book.books[self.book.id]?.description }
  private lazy var bookScoreSignal = ApplicationStore.shared.createSignal { $0.book.books[self.book.id]?.score ?? 0 }


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Overrides
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

    // Subscribe a store.
    ApplicationStore.shared.subscribe(self, connectTo: [self.bookTitleSignal, self.bookDescriptionSignal, self.bookScoreSignal])
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Unsubscribe a store to avoid memory leaks.
    ApplicationStore.shared.unsubscribe(self)
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = Rows(rawValue: indexPath.row) ?? Rows.summary

    switch row {
    case .summary:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: BooksDetailSummaryTableViewCell.identifier,
        for: indexPath
      ) as? BooksDetailSummaryTableViewCell else { return UITableViewCell() }
      
      cell.prepare(titleSignal: self.bookTitleSignal, descriptionSignal: self.bookDescriptionSignal)

      return cell
    case .score:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: BooksDetailScoreTableViewCell.identifier,
        for: indexPath
      ) as? BooksDetailScoreTableViewCell else { return UITableViewCell() }

      cell.prepare(bookId: self.book.id, scoreSignal: self.bookScoreSignal)

      return cell
    case .edit:
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: BooksDetailEditTableViewCell.identifier,
        for: indexPath
      ) as? BooksDetailEditTableViewCell else { return UITableViewCell() }

      return cell
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let row = Rows(rawValue: indexPath.row) ?? Rows.summary

    switch row {
    case .summary: return 416.0
    case .score: return 136.0
    case .edit: return 89.0
    }
  }

  // MARK: Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(book: BookModel) {
    self.book = book
  }

}
