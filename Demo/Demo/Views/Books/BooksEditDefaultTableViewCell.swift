// =============================================================================================================================
// DEMO - VIEWS - BOOKS - BOOKS EDIT DEFAULT TABLE VIEW CELL
// =============================================================================================================================
import UIKit

final class BooksEditDefaultTableViewCell: UITableViewCell {

  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Variables
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Structs
  struct BooksEditItem {
    let name: String
    let initialValue: String?
    let didInputTextFieldHandler: ((String?) -> Void)
  }

  // MARK: Internal Variables
  static var identifier: String { return "default" }
  private(set) var didInputTextFieldHandler: ((String?) -> Void)!

  // MARK: IBOutlet Variables
  @IBOutlet weak private var nameLabel: UILabel!
  @IBOutlet weak private var textField: UITextField!


  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: - Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  // MARK: Internal Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  func prepare(item: BooksEditItem) {
    self.didInputTextFieldHandler = item.didInputTextFieldHandler
    self.textField.addTarget(self, action: #selector(self.didInputText), for: .editingChanged)

    self.bindToAppearance(item: item)
  }

  // MARK: Private Functions
  // ---------------------------------------------------------------------------------------------------------------------------
  private func bindToAppearance(item: BooksEditItem) {
    self.nameLabel.text = item.name
    self.textField.text = item.initialValue
  }

  @objc private func didInputText(_ sender: UITextField) {
    self.didInputTextFieldHandler(sender.text)
  }
  
}
