// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS EDIT VIEW CONTROLLER + UI TABLE VIEW
// =============================================================================================================================
import UIKit

fileprivate typealias Delegate = UITableViewDelegate
fileprivate typealias DataSource = UITableViewDataSource
extension BooksEditViewController: Delegate, DataSource {

  // ---------------------------------------------------------------------------------------------------------------------------
  // Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // Define private variables.
  private typealias FieldItem = BooksEditDefaultTableViewCell.BooksEditItem
  private var fieldItems: [FieldItem] {
    return [
      FieldItem(
        name: "Title",
        initialValue: self.bookTitle,
        didInputTextFieldHandler: self.didInputTitleTextField
      ),
      FieldItem(
        name: "Description",
        initialValue: self.bookDescription,
        didInputTextFieldHandler: self.didInputDescriptionTextField
      ),
    ]
  }


  // ---------------------------------------------------------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.fieldItems.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: BooksEditDefaultTableViewCell = tableView.dequeueReusableCell(
      withIdentifier: BooksEditDefaultTableViewCell.identifier,
      for: indexPath
      ) as? BooksEditDefaultTableViewCell else { return UITableViewCell() }

    let item: FieldItem = self.fieldItems[indexPath.row]
    cell.prepare(item: item)

    return cell
  }

  // Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func didInputTitleTextField(_ text: String?) {
    guard let text: String = text else {
      self.navigationBarSaveButton.isEnabled = false
      return
    }

    self.navigationBarSaveButton.isEnabled = !text.isEmpty
    self.bookTitle = text
  }

  private func didInputDescriptionTextField(_ text: String?) {
    self.bookDescription = text
  }

}
